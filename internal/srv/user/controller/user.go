package controller

import (
	"github.com/gofiber/fiber/v2"
	"github.com/lutracorp/lutrachat/internal/pkg/database"
	"github.com/lutracorp/lutrachat/internal/pkg/server/http"
	"github.com/lutracorp/lutrachat/internal/pkg/server/http/middleware"
	"github.com/lutracorp/lutrachat/internal/srv/user/model"
)

// Get returns a public user object for a given user ID.
func Get(ctx *fiber.Ctx) error {
	prm := &model.GetParams{}
	if err := ctx.ParamsParser(prm); err != nil {
		return http.MalformedRequestValidationError
	}

	u, err := database.GetOne[database.User](ctx.Context(), "id = ?", prm.UserID)
	if err != nil {
		return http.UserUnknownError
	}

	pu := u.AsPublicUser()

	return ctx.JSON(&pu)
}

// GetCurrent returns a private user object of the requester's account.
func GetCurrent(ctx *fiber.Ctx) error {
	user := ctx.Locals(middleware.LocalsUser).(*database.User)
	pu := user.AsPrivateUser()

	return ctx.JSON(&pu)
}
