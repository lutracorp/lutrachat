package middleware

import (
	"github.com/gofiber/fiber/v2"
	"github.com/lutracorp/lutrachat/internal/pkg/database"
	"github.com/lutracorp/lutrachat/internal/pkg/server/http"
)

const (
	LocalsUser = "chat.lutracorp.su/user" // Locals key used to store authenticated user data.
)

// User middleware extracts forwarded user to requests locals.
func User(ctx *fiber.Ctx) error {
	uid := ctx.Locals(LocalsUserID).(string)
	user, err := database.GetOne[database.User](ctx.Context(), "id = ?", uid)
	if err != nil {
		return http.UserUnknownError
	}

	ctx.Locals(LocalsUser, user)

	return ctx.Next()
}
