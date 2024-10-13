package controller

import (
	"github.com/gofiber/fiber/v2"
	"github.com/lutracorp/foxid-go"
	"github.com/lutracorp/lutrachat/api/protocol/pkg/kdf/v1"
	"github.com/lutracorp/lutrachat/internal/pkg/database"
	"github.com/lutracorp/lutrachat/internal/pkg/kdf"
	"github.com/lutracorp/lutrachat/internal/pkg/server/http"
	"github.com/lutracorp/lutrachat/internal/pkg/token"
	"github.com/lutracorp/lutrachat/internal/srv/authentication/model"
	"google.golang.org/protobuf/proto"
)

// AccountLogin retrieves an authentication token for the given credentials.
func AccountLogin(ctx *fiber.Ctx) error {
	body := &model.AccountLoginSchema{}
	if err := ctx.BodyParser(body); err != nil {
		return http.MalformedBodyValidationError
	}

	user, err := database.GetOne[database.User](ctx.Context(), "email = ?", body.Email)
	if err != nil {
		return http.InvalidCredentialsRestrictionError
	}

	kr := &v1.KdfResult{}
	if err := proto.Unmarshal(user.Password, kr); err != nil {
		return http.GeneralError
	}

	if kdf.Verify([]byte(body.Password), kr) {
		id, err := foxid.Parse(user.ID)
		if err != nil {
			return http.GeneralError
		}

		tok, err := token.Sign(id.Bytes(), user.Password)
		if err != nil {
			return http.GeneralError
		}

		toks, err := token.Marshal(tok)
		if err != nil {
			return http.GeneralError
		}

		tokr := &model.TokenResponse{Token: toks}
		return ctx.JSON(tokr)
	}

	return http.InvalidCredentialsRestrictionError
}

// AccountRegister creates a new account and retrieves an authentication token for the given credentials.
func AccountRegister(ctx *fiber.Ctx) error {
	body := &model.AccountRegisterSchema{}
	if err := ctx.BodyParser(body); err != nil {
		return http.MalformedBodyValidationError
	}

	kr, err := kdf.Derive([]byte(body.Password))
	if err != nil {
		return http.GeneralError
	}

	krm, err := proto.Marshal(kr)
	if err != nil {
		return http.GeneralError
	}

	uid := foxid.Generate()
	usr := &database.User{ID: uid.String(), Name: body.Name, Email: body.Email, Password: krm}
	if err := database.AddOne(ctx.Context(), usr); err != nil {
		return http.CredentialsAlreadyUsedLimitationError
	}

	tok, err := token.Sign(uid.Bytes(), krm)
	if err != nil {
		return http.GeneralError
	}

	toks, err := token.Marshal(tok)
	if err != nil {
		return http.GeneralError
	}

	tokr := &model.TokenResponse{Token: toks}
	return ctx.JSON(tokr)
}
