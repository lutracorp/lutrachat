package middleware

import (
	"github.com/gofiber/fiber/v2"
	"github.com/lutracorp/lutrachat/internal/pkg/database"
)

// ChannelKey used to storage channel data in fiber context locals.
const ChannelKey = "chat.lutracorp.su/channel"

// Channel check channel for existence.
func Channel(param string) fiber.Handler {
	return func(ctx *fiber.Ctx) error {
		cid := ctx.Params(param)

		c, err := database.GetOne[database.Channel](ctx.Context(), "id = ?", cid)
		if err != nil {
			return ctx.Status(fiber.StatusNotFound).JSON(fiber.Map{})
		}

		ctx.Locals(ChannelKey, c)

		return ctx.Next()
	}
}
