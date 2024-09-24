package route

import (
	"github.com/gofiber/fiber/v2"
	"github.com/lutracorp/lutrachat/internal/app/api/controller"
	"github.com/lutracorp/lutrachat/internal/app/api/middleware"
)

// RecipientRoute binds message related routes to server.
func RecipientRoute(srv *fiber.App) error {
	rg := srv.Group("/channels/:channel/recipients", middleware.Authorization, middleware.Channel("channel"), middleware.Recipient)

	rg.Get("/", controller.RecipientList)

	return nil
}
