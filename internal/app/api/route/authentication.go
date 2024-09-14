package route

import (
	"github.com/gofiber/fiber/v2"
	"github.com/lutracorp/lutrachat/internal/app/api/controller"
)

// AuthenticationRoute binds authentication related routes to server.
func AuthenticationRoute(srv *fiber.App) error {
	group := srv.Group("/authentication")

	group.Post("/login", controller.AuthenticationLogin)
	group.Post("/register", controller.AuthenticationRegister)

	return nil
}
