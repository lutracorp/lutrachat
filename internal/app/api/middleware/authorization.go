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

// AuthorizationMiddleware checks authorization header for validity.
func AuthorizationMiddleware(c *fiber.Ctx) error {
	hv := c.Get("Authorization")

	tn := &v1.TokenData{}
	if err := token.Unmarshal(hv, tn); err != nil {
		return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{})
	}
	if proto.Size(tn) == 0 || len(tn.Payload) != 16 {
		return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{})
	}

	id := foxid.FOxID(tn.Payload)
	ids := id.String()

	user, err := database.GetOne(c.Context(), &database.User{ID: ids})
	if err != nil {
		return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{})
	}

	if ver, err := token.Verify(tn, user.Password); err != nil || !ver {
		return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{})
	}

	c.Locals(UserKey, user)

	return c.Next()
}
