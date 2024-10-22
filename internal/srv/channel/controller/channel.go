package controller

import (
	"github.com/lutracorp/lutrachat/internal/pkg/server/http/middleware"
	"github.com/samber/lo"

	"github.com/gofiber/fiber/v2"
	"github.com/lutracorp/foxid-go"
	"github.com/lutracorp/lutrachat/internal/pkg/database"
	"github.com/lutracorp/lutrachat/internal/pkg/server/http"
	"github.com/lutracorp/lutrachat/internal/srv/channel/model"
)

// List returns a list of channel objects the user is participating in.
func List(ctx *fiber.Ctx) error {
	uid := ctx.Locals(middleware.LocalsUserID).(string)

	recs, err := database.GetMany[database.Recipient](ctx.Context(), "user_id = ?", uid)
	if err != nil {
		return http.GeneralError
	}

	cids := lo.Map(*recs, func(rec database.Recipient, _ int) string {
		return rec.ChannelID
	})

	chns, err := database.GetMany[database.Channel](ctx.Context(), "id IN ?", cids)
	if err != nil {
		return http.GeneralError
	}

	return ctx.JSON(&chns)
}

// Create creates a new channel.
func Create(ctx *fiber.Ctx) error {
	body := &model.CreateSchema{}
	if err := ctx.BodyParser(body); err != nil {
		return http.MalformedRequestValidationError
	}

	cid := foxid.Generate()
	chn := database.Channel{
		ID:   cid.String(),
		Type: body.Type,
		Name: body.Name,
	}

	uid := ctx.Locals(middleware.LocalsUserID).(string)
	nrs := append(body.Recipients, uid)
	urs := lo.Uniq(nrs)

	ral := lo.Map(urs, func(ruid string, _ int) *database.Recipient {
		rid := foxid.Generate()
		return &database.Recipient{
			ID:        rid.String(),
			UserID:    ruid,
			ChannelID: chn.ID,
		}
	})

	if err := database.AddOne(ctx.Context(), &chn); err != nil {
		return http.GeneralError
	}

	if err := database.AddMany(ctx.Context(), &ral); err != nil {
		return http.GeneralError
	}

	return ctx.JSON(chn)
}

// Get returns a channel object for a given channel ID.
func Get(ctx *fiber.Ctx) error {
	prm := &model.GetParams{}
	if err := ctx.ParamsParser(prm); err != nil {
		return http.MalformedRequestValidationError
	}

	chn, err := database.GetOne[database.Channel](ctx.Context(), "id = ?", prm.ChannelID)
	if err != nil {
		return http.ChannelUnknownError
	}

	uid := ctx.Locals(middleware.LocalsUserID).(string)
	if _, err := database.GetOne[database.Recipient](ctx.Context(), "user_id = ? AND channel_id = ?", uid, chn.ID); err != nil {
		return http.ChannelUnknownError
	}

	return ctx.JSON(chn)
}
