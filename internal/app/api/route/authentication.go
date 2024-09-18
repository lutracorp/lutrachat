package route

import (
	"github.com/gofiber/fiber/v2"
	"github.com/lutracorp/lutrachat/internal/app/api/controller"
)

// AuthenticationRoute binds authentication related routes to server.
func AuthenticationRoute(srv *fiber.App) error {
	rg := srv.Group("/authentication")

	rg.Post("/login", controller.AuthenticationLogin)
	rg.Post("/register", controller.AuthenticationRegister)

	return nil
}
