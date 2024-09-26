package route

import (
	"github.com/gofiber/fiber/v2"
	"github.com/lutracorp/lutrachat/internal/app/api/controller"
	"github.com/lutracorp/lutrachat/internal/app/api/middleware"
)

// MessageRoute binds message related routes to server.
func MessageRoute(srv *fiber.App) {
	rg := srv.Group("/channels/:channel/messages", middleware.Authorization, middleware.Channel("channel"), middleware.Recipient)

	rg.Get("/", controller.MessageList)
	rg.Post("/", controller.MessageCreate)

	mg := rg.Group("/:message")

	mg.Get("/", controller.MessageGet)
}
