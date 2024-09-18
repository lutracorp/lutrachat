package middleware

import (
	"github.com/gofiber/fiber/v2"
	"github.com/lutracorp/foxid-go"
	v1 "github.com/lutracorp/lutrachat/api/protocol/struct/v1"
	"github.com/lutracorp/lutrachat/internal/pkg/database"
	"github.com/lutracorp/lutrachat/internal/pkg/token"
	"google.golang.org/protobuf/proto"
)

// UserKey used to storage User data in fiber context locals.
const UserKey = "chat.lutracorp.su/user"

// Authorization checks authorization header for validity.
func Authorization(ctx *fiber.Ctx) error {
	hv := ctx.Get("Authorization")

	tn := &v1.TokenData{}
	if err := token.Unmarshal(hv, tn); err != nil {
		return ctx.Status(fiber.StatusUnauthorized).JSON(fiber.Map{})
	}
	if proto.Size(tn) == 0 || len(tn.Payload) != 16 {
		return ctx.Status(fiber.StatusUnauthorized).JSON(fiber.Map{})
	}

	id := foxid.FOxID(tn.Payload)
	ids := id.String()

	user, err := database.GetOne(ctx.Context(), &database.User{ID: ids})
	if err != nil {
		return ctx.Status(fiber.StatusUnauthorized).JSON(fiber.Map{})
	}

	if ver, err := token.Verify(tn, user.Password); err != nil || !ver {
		return ctx.Status(fiber.StatusUnauthorized).JSON(fiber.Map{})
	}

	ctx.Locals(UserKey, user)

	return ctx.Next()
}
