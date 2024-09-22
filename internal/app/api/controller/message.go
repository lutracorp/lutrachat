package controller

import (
	"fmt"

	"github.com/gofiber/fiber/v2"
	"github.com/lutracorp/foxid-go"
	"github.com/lutracorp/lutrachat/internal/app/api/middleware"
	"github.com/lutracorp/lutrachat/internal/app/api/model"
	"github.com/lutracorp/lutrachat/internal/pkg/database"
	"gorm.io/gorm/clause"
)

const messagesLimit uint8 = 50

// MessageGet returns a message object for a given Message ID.
func MessageGet(ctx *fiber.Ctx) error {
	mid := ctx.Params("message")
	cid := ctx.Params("channel")

	m, err := database.GetOne[database.Message](ctx.Context(), "id = ? AND channel_id = ?", mid, cid)
	if err != nil {
		return ctx.Status(fiber.StatusNotFound).JSON(fiber.Map{})
	}

	return ctx.JSON(&m)
}

// MessageList returns multiple message objects in given channel that matches the criteria.
func MessageList(ctx *fiber.Ctx) error {
	chn := ctx.Locals(middleware.ChannelKey).(*database.Channel)

	query := &model.MessageListQuery{}
	if err := ctx.QueryParser(query); err != nil {
		return ctx.Status(fiber.StatusBadRequest).JSON(fiber.Map{})
	}

	clauses := make([]clause.Expression, 0)

	if query.Type != nil {
		clauses = append(clauses, clause.Eq{Column: "type", Value: query.Type})
	}

	if query.Limit == 0 {
		query.Limit = messagesLimit
	}

	if query.After != "" {
		clauses = append(clauses, clause.Gt{Column: "id", Value: query.After})
	}

	if query.Before != "" {
		clauses = append(clauses, clause.Lt{Column: "id", Value: query.Before})
	}

	var msgs []database.Message
	if err := database.DB.WithContext(ctx.Context()).Where("channel_id = ?", chn.ID).Clauses(clauses...).Order(clause.OrderBy{Columns: []clause.OrderByColumn{{Column: clause.Column{Name: "id"}, Desc: true}}}).Limit(int(query.Limit)).Find(&msgs).Error; err != nil {
		return ctx.Status(fiber.StatusInternalServerError).JSON(fiber.Map{})
	}

	return ctx.JSON(&msgs)
}

// MessageCreate publishes message in given channel.
func MessageCreate(ctx *fiber.Ctx) error {
	rec := ctx.Locals(middleware.RecipientKey).(*database.Recipient)

	body := &model.MessageCreateSchema{}
	if err := ctx.BodyParser(body); err != nil {
		fmt.Println(err)
		return ctx.Status(fiber.StatusBadRequest).JSON(fiber.Map{})
	}

	mid := foxid.Generate()
	msg := &database.Message{
		ID:        mid.String(),
		Type:      body.Type,
		Content:   body.Content,
		AuthorID:  rec.UserID,
		ChannelID: rec.ChannelID,
	}

	err := database.AddOne(ctx.Context(), msg)
	if err != nil {
		return ctx.Status(fiber.StatusInternalServerError).JSON(fiber.Map{})
	}

	return ctx.JSON(&msg)
}
