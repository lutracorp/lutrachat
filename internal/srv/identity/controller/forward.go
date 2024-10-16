package controller

import (
	"github.com/gofiber/fiber/v2"
	"github.com/lutracorp/foxid-go"
	v1 "github.com/lutracorp/lutrachat/api/protocol/pkg/token/v1"
	"github.com/lutracorp/lutrachat/internal/pkg/database"
	"github.com/lutracorp/lutrachat/internal/pkg/server/http"
	"github.com/lutracorp/lutrachat/internal/pkg/token"
	"github.com/lutracorp/lutrachat/internal/srv/identity/model"
	"google.golang.org/protobuf/proto"
)

// Forward forwards authorization data to proxy.
func Forward(ctx *fiber.Ctx) error {
	ahv := ctx.Get("Authorization")

	td := &v1.TokenData{}
	if err := token.Unmarshal(ahv, td); err != nil {
		return http.InvalidCredentialsRestrictionError
	}
	if proto.Size(td) == 0 || len(td.Payload) != 16 {
		return http.InvalidCredentialsRestrictionError
	}

	id := foxid.FOxID(td.Payload)
	user, err := database.GetOne[database.User](ctx.Context(), "id = ?", id.String())
	if err != nil {
		return http.InvalidCredentialsRestrictionError
	}

	if ver, err := token.Verify(td, user.Password); err != nil || !ver {
		return http.InvalidCredentialsRestrictionError
	}

	fr := &model.ForwardResponse{
		UserID: user.ID,
	}

	ctx.Set("X-User-Id", fr.UserID)
	return ctx.Status(fiber.StatusOK).JSON(fr)
}
