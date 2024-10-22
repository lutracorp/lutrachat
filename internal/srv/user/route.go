package user

import (
	"github.com/gofiber/fiber/v2"
	"github.com/lutracorp/lutrachat/internal/pkg/server/http/middleware"
	"github.com/lutracorp/lutrachat/internal/srv/user/controller"
)

// Route mounts user routes to fiber.App.
func Route(app *fiber.App) {
	root := app.Group("/users", middleware.Forward)

	root.Get("/@me", middleware.User, controller.GetCurrent)
	root.Get("/:user_id", controller.Get)
}
