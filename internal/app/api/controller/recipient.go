package controller

import (
	"github.com/gofiber/fiber/v2"
	"github.com/lutracorp/lutrachat/internal/app/api/middleware"
	"github.com/lutracorp/lutrachat/internal/pkg/database"
)

// RecipientList returns recipients in given channel.
func RecipientList(ctx *fiber.Ctx) error {
	chn := ctx.Locals(middleware.ChannelKey).(*database.Channel)

	recs, err := database.GetMany[database.Recipient](ctx.Context(), "channel_id = ?", chn.ID)
	if err != nil {
		return err
	}

	return ctx.Status(fiber.StatusOK).JSON(recs)
}
