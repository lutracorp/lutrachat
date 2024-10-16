package identity

import (
	"github.com/gofiber/fiber/v2"
	"github.com/lutracorp/lutrachat/internal/srv/identity/controller"
)

// Route mounts identity routes to fiber.App.
func Route(app *fiber.App) {
	root := app.Group("/identity")

	root.Get("/forward", controller.Forward)
}
