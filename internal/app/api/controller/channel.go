package controller

import (
	"github.com/gofiber/fiber/v2"
	"github.com/lutracorp/foxid-go"
	"github.com/lutracorp/lutrachat/internal/app/api/middleware"
	"github.com/lutracorp/lutrachat/internal/app/api/model"
	"github.com/lutracorp/lutrachat/internal/pkg/database"
	"slices"
)

// ChannelGet returns a channel object for a given channel ID.
func ChannelGet(ctx *fiber.Ctx) error {
	c := ctx.Locals(middleware.ChannelKey).(*database.Channel)

	return ctx.JSON(&c)
}

// ChannelList returns a list of channel objects the user is participating in.
func ChannelList(ctx *fiber.Ctx) error {
	u := ctx.Locals(middleware.UserKey).(*database.User)

	recs, err := database.GetMany[database.Recipient](ctx.Context(), "user_id = ?", u.ID)
	if err != nil {
		return ctx.Status(fiber.StatusInternalServerError).JSON(fiber.Map{})
	}

	cids := make([]string, len(*recs))
	for ind, rec := range *recs {
		cids[ind] = rec.ChannelID
	}

	chns, err := database.GetMany[database.Channel](ctx.Context(), "id IN ?", cids)
	if err != nil {
		return ctx.Status(fiber.StatusInternalServerError).JSON(fiber.Map{})
	}

	return ctx.JSON(&chns)
}

// ChannelCreate creates a new channel.
func ChannelCreate(ctx *fiber.Ctx) error {
	usr := ctx.Locals(middleware.UserKey).(*database.User)

	body := &model.ChannelCreateSchema{}
	if err := ctx.BodyParser(body); err != nil {
		return ctx.Status(fiber.StatusBadRequest).JSON(fiber.Map{})
	}

	cid := foxid.Generate()
	chn := &database.Channel{
		ID:   cid.String(),
		Type: body.Type,
		Name: body.Name,
	}

	irec := append(body.Recipients, usr.ID)
	slices.Sort(irec)
	recs := slices.Compact(irec)

	ral := make([]*database.Recipient, len(recs))
	for rind, uid := range recs {
		rid := foxid.Generate()
		ral[rind] = &database.Recipient{
			ID:        rid.String(),
			UserID:    uid,
			ChannelID: chn.ID,
		}
	}

	if err := database.AddOne(ctx.Context(), &chn); err != nil {
		return ctx.Status(fiber.StatusInternalServerError).SendString(err.Error())
	}

	if err := database.AddMany(ctx.Context(), &ral); err != nil {
		return ctx.Status(fiber.StatusInternalServerError).SendString(err.Error())
	}

	return ctx.Status(fiber.StatusCreated).JSON(chn)
}
