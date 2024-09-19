package controller

import (
	"github.com/gofiber/fiber/v2"
	"github.com/lutracorp/lutrachat/internal/app/api/middleware"
	"github.com/lutracorp/lutrachat/internal/pkg/database"
)

// UserGetCurrent returns a private user object of the requester's account.
func UserGetCurrent(ctx *fiber.Ctx) error {
	u := ctx.Locals(middleware.UserKey).(*database.User)
	up := u.AsPrivateUser()

	return ctx.JSON(&up)
}

// UserGet returns a public user object for a given user ID.
func UserGet(ctx *fiber.Ctx) error {
	uid := ctx.Params("user")

	u, err := database.GetOne[database.User](ctx.Context(), "id = ?", uid)
	if err != nil {
		return ctx.Status(fiber.StatusNotFound).JSON(fiber.Map{})
	}

	up := u.AsPublicUser()

	return ctx.JSON(&up)
}
