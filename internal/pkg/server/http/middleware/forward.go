package middleware

import (
	"github.com/gofiber/fiber/v2"
	"github.com/lutracorp/lutrachat/internal/pkg/server/http"
)

// ForwardedRequestHeaders represents forwarded request headers.
type ForwardedRequestHeaders struct {
	UserID string `reqHeader:"x-user-id"` // UserID contains forwarded user id.
}

const (
	LocalsUserID = "chat.lutracorp.su/userID" // Locals key used to store authenticated user id.
)

// Forward middleware extracts forwarded request headers to requests locals.
func Forward(ctx *fiber.Ctx) error {
	header := &ForwardedRequestHeaders{}
	if err := ctx.ReqHeaderParser(header); err != nil {
		return http.MalformedRequestValidationError
	}

	ctx.Locals(LocalsUserID, header.UserID)

	return ctx.Next()
}
