package middleware

import (
	"github.com/gofiber/fiber/v2"
	"github.com/lutracorp/lutrachat/internal/pkg/database"
)

// RecipientKey used to storage recipient data in fiber context locals.
const RecipientKey = "chat.lutracorp.su/recipient"

// Recipient check recipient for existence.
func Recipient(ctx *fiber.Ctx) error {
	u := ctx.Locals(UserKey).(*database.User)
	c := ctx.Locals(ChannelKey).(*database.Channel)

	r, err := database.GetOne[database.Recipient](ctx.Context(), "user_id = ? AND channel_id = ?", u.ID, c.ID)
	if err != nil {
		return ctx.Status(fiber.StatusForbidden).JSON(fiber.Map{})
	}

	ctx.Locals(RecipientKey, r)

	return ctx.Next()
}
