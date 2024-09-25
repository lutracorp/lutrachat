package controller

import (
	"github.com/gofiber/fiber/v2"
	"github.com/lutracorp/foxid-go"
	"github.com/lutracorp/lutrachat/api/protocol/pkg/kdf/v1"
	"github.com/lutracorp/lutrachat/internal/app/api/model"
	"github.com/lutracorp/lutrachat/internal/pkg/database"
	"github.com/lutracorp/lutrachat/internal/pkg/kdf"
	"github.com/lutracorp/lutrachat/internal/pkg/token"
	"google.golang.org/protobuf/proto"
)

// AuthenticationLogin retrieves an authentication token for the given credentials.
func AuthenticationLogin(ctx *fiber.Ctx) error {
	body := &model.AuthenticationLoginSchema{}
	if err := ctx.BodyParser(body); err != nil {
		return ctx.Status(fiber.StatusBadRequest).JSON(fiber.Map{})
	}

	user, err := database.GetOne[database.User](ctx.Context(), "email = ?", body.Email)
	if err != nil {
		return ctx.Status(fiber.StatusNotFound).JSON(fiber.Map{})
	}

	kdfr := &v1.KdfResult{}
	if err := proto.Unmarshal(user.Password, kdfr); err != nil {
		return ctx.Status(fiber.StatusBadRequest).JSON(fiber.Map{})
	}

	if kdf.Verify([]byte(body.Password), kdfr) {
		id, err := foxid.Parse(user.ID)
		if err != nil {
			return ctx.Status(fiber.StatusInternalServerError).JSON(fiber.Map{})
		}

		tok, err := token.Sign(id.Bytes(), user.Password)
		if err != nil {
			return ctx.Status(fiber.StatusInternalServerError).JSON(fiber.Map{})
		}

		toks, err := token.Marshal(tok)
		if err != nil {
			return ctx.Status(fiber.StatusInternalServerError).JSON(fiber.Map{})
		}

		tokr := &model.AuthenticationTokenResponse{Token: toks}

		return ctx.Status(fiber.StatusOK).JSON(tokr)
	}

	return ctx.Status(fiber.StatusUnauthorized).JSON(fiber.Map{})
}

// AuthenticationRegister creates a new account and retrieves an authentication token for the given credentials.
func AuthenticationRegister(ctx *fiber.Ctx) error {
	body := &model.AuthenticationRegisterSchema{}
	if err := ctx.BodyParser(body); err != nil {
		return ctx.Status(fiber.StatusBadRequest).JSON(fiber.Map{})
	}

	ph, err := kdf.Derive([]byte(body.Password))
	if err != nil {
		return ctx.Status(fiber.StatusInternalServerError).JSON(fiber.Map{})
	}

	phb, err := proto.Marshal(ph)
	if err != nil {
		return ctx.Status(fiber.StatusInternalServerError).JSON(fiber.Map{})
	}

	uid := foxid.Generate()
	usr := &database.User{
		ID:       uid.String(),
		Name:     body.Name,
		Email:    body.Email,
		Password: phb,
	}
	if err := database.AddOne(ctx.Context(), usr); err != nil {
		return ctx.Status(fiber.StatusConflict).JSON(fiber.Map{})
	}

	tok, err := token.Sign(uid.Bytes(), phb)
	if err != nil {
		return ctx.Status(fiber.StatusInternalServerError).JSON(fiber.Map{})
	}

	toks, err := token.Marshal(tok)
	if err != nil {
		return ctx.Status(fiber.StatusInternalServerError).JSON(fiber.Map{})
	}

	tokr := &model.AuthenticationTokenResponse{Token: toks}

	return ctx.Status(fiber.StatusCreated).JSON(tokr)
}
