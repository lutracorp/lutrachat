package route

import (
	"github.com/gofiber/fiber/v2"
	"github.com/lutracorp/lutrachat/internal/app/api/controller"
	"github.com/lutracorp/lutrachat/internal/app/api/middleware"
)

// ChannelRoute binds channel related routes to server.
func ChannelRoute(srv *fiber.App) {
	rg := srv.Group("/channels", middleware.Authorization)

	rg.Get("/", controller.ChannelList)
	rg.Post("/", controller.ChannelCreate)

	cg := rg.Group("/:channel", middleware.Channel("channel"), middleware.Recipient)

	cg.Get("/", controller.ChannelGet)
}
