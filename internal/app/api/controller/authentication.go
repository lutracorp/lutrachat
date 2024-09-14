package controller

import (
	"github.com/gofiber/fiber/v2"
	"github.com/lutracorp/foxid-go"
	v1 "github.com/lutracorp/lutrachat/api/protocol/struct/v1"
	"github.com/lutracorp/lutrachat/internal/app/api/model"
	"github.com/lutracorp/lutrachat/internal/pkg/database"
	"github.com/lutracorp/lutrachat/internal/pkg/kdf"
	"github.com/lutracorp/lutrachat/internal/pkg/token"
	"google.golang.org/protobuf/proto"
)

// AuthenticationLogin retrieves an authentication token for the given credentials.
func AuthenticationLogin(ctx *fiber.Ctx) error {
	payload := &model.LoginPayload{}
	if err := ctx.BodyParser(payload); err != nil {
		return ctx.Status(fiber.StatusBadRequest).JSON(fiber.Map{})
	}

	user, err := database.GetOne(ctx.Context(), &database.User{Email: payload.Email})
	if err != nil {
		return ctx.Status(fiber.StatusNotFound).JSON(fiber.Map{})
	}

	kdfr := &v1.KdfResult{}
	if err := proto.Unmarshal(user.Password, kdfr); err != nil {
		return ctx.Status(fiber.StatusBadRequest).JSON(fiber.Map{})
	}

	if kdf.Verify([]byte(payload.Password), kdfr) {
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

		tokr := &model.TokenResponse{Token: toks}

		return ctx.Status(fiber.StatusOK).JSON(tokr)
	}

	return ctx.Status(fiber.StatusUnauthorized).JSON(fiber.Map{})
}

// AuthenticationRegister creates a new account and retrieves an authentication token for the given credentials.
func AuthenticationRegister(ctx *fiber.Ctx) error {
	payload := &model.RegisterPayload{}
	if err := ctx.BodyParser(payload); err != nil {
		return ctx.Status(fiber.StatusBadRequest).JSON(fiber.Map{})
	}

	ph, err := kdf.Derive([]byte(payload.Password))
	if err != nil {
		return ctx.Status(fiber.StatusInternalServerError).JSON(fiber.Map{})
	}

	phb, err := proto.Marshal(ph)
	if err != nil {
		return ctx.Status(fiber.StatusInternalServerError).JSON(fiber.Map{})
	}

	id := foxid.Generate()
	if err := database.AddOne(
		ctx.Context(),
		&database.User{
			ID:       id.String(),
			Name:     payload.Name,
			Email:    payload.Email,
			Password: phb,
		},
	); err != nil {
		return ctx.Status(fiber.StatusConflict).JSON(fiber.Map{})
	}

	tok, err := token.Sign(id.Bytes(), phb)
	if err != nil {
		return ctx.Status(fiber.StatusInternalServerError).JSON(fiber.Map{})
	}

	toks, err := token.Marshal(tok)
	if err != nil {
		return ctx.Status(fiber.StatusInternalServerError).JSON(fiber.Map{})
	}

	tokr := &model.TokenResponse{Token: toks}

	return ctx.Status(fiber.StatusCreated).JSON(tokr)
}
