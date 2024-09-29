package controller

import (
	"github.com/gofiber/fiber/v2"
	"github.com/lutracorp/foxid-go"
	"github.com/lutracorp/lutrachat/api/protocol/pkg/kdf/v1"
	"github.com/lutracorp/lutrachat/internal/pkg/database"
	"github.com/lutracorp/lutrachat/internal/pkg/kdf"
	"github.com/lutracorp/lutrachat/internal/pkg/server"
	"github.com/lutracorp/lutrachat/internal/pkg/server/http"
	"github.com/lutracorp/lutrachat/internal/pkg/token"
	"github.com/lutracorp/lutrachat/internal/srv/authentication/model"
	"google.golang.org/protobuf/proto"
)

// AccountLogin retrieves an authentication token for the given credentials.
func AccountLogin(ctx *fiber.Ctx) error {
	body := &model.AccountLoginSchema{}
	if err := ctx.BodyParser(body); err != nil {
		return http.NewHTTPError(server.ValidationErrorKind, server.MalformedBodyValidationErrorCode)
	}

	user, err := database.GetOne[database.User](ctx.Context(), "email = ?", body.Email)
	if err != nil {
		return http.NewHTTPError(server.DisallowedActionErrorKind, server.UnauthorizedDisallowedActionErrorCode)
	}

	kr := &v1.KdfResult{}
	if err := proto.Unmarshal(user.Password, kr); err != nil {
		return http.NewHTTPError(server.GeneralErrorKind, server.UnknownGeneralErrorCode)
	}

	if kdf.Verify([]byte(body.Password), kr) {
		id, err := foxid.Parse(user.ID)
		if err != nil {
			return http.NewHTTPError(server.GeneralErrorKind, server.UnknownGeneralErrorCode)
		}

		tok, err := token.Sign(id.Bytes(), user.Password)
		if err != nil {
			return http.NewHTTPError(server.GeneralErrorKind, server.UnknownGeneralErrorCode)
		}

		toks, err := token.Marshal(tok)
		if err != nil {
			return http.NewHTTPError(server.GeneralErrorKind, server.UnknownGeneralErrorCode)
		}

		tokr := &model.TokenResponse{Token: toks}
		return ctx.JSON(tokr)
	}

	return http.NewHTTPError(server.DisallowedActionErrorKind, server.UnauthorizedDisallowedActionErrorCode)
}

// AccountRegister creates a new account and retrieves an authentication token for the given credentials.
func AccountRegister(ctx *fiber.Ctx) error {
	body := &model.AccountRegisterSchema{}
	if err := ctx.BodyParser(body); err != nil {
		return http.NewHTTPError(server.ValidationErrorKind, server.MalformedBodyValidationErrorCode)
	}

	kr, err := kdf.Derive([]byte(body.Password))
	if err != nil {
		return http.NewHTTPError(server.GeneralErrorKind, server.UnknownGeneralErrorCode)
	}

	krm, err := proto.Marshal(kr)
	if err != nil {
		return http.NewHTTPError(server.GeneralErrorKind, server.UnknownGeneralErrorCode)
	}

	uid := foxid.Generate()
	usr := &database.User{ID: uid.String(), Name: body.Name, Email: body.Email, Password: krm}
	if err := database.AddOne(ctx.Context(), usr); err != nil {
		return http.NewHTTPError(server.DisallowedActionErrorKind, server.ConflictDisallowedActionErrorCode)
	}

	tok, err := token.Sign(uid.Bytes(), krm)
	if err != nil {
		return http.NewHTTPError(server.GeneralErrorKind, server.UnknownGeneralErrorCode)
	}

	toks, err := token.Marshal(tok)
	if err != nil {
		return http.NewHTTPError(server.GeneralErrorKind, server.UnknownGeneralErrorCode)
	}

	tokr := &model.TokenResponse{Token: toks}
	return ctx.JSON(tokr)
}
