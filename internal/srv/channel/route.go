package channel

import (
	"github.com/gofiber/fiber/v2"
	"github.com/lutracorp/lutrachat/internal/pkg/server/http/middleware"
	"github.com/lutracorp/lutrachat/internal/srv/channel/controller"
)

// Route mounts channel routes to fiber.App.
func Route(app *fiber.App) {
	root := app.Group("/channels", middleware.Forward)

	root.Get("/", controller.List)
	root.Post("/", controller.Create)

	channel := root.Group("/:channel_id")

	channel.Get("/", controller.Get)
}
