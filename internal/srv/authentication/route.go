package authentication

import (
	"github.com/gofiber/fiber/v2"
	"github.com/lutracorp/lutrachat/internal/srv/authentication/controller"
)

// Route mounts authentication routes to fiber.App.
func Route(app *fiber.App) {
	root := app.Group("/authentication")

	account := root.Group("/account")
	account.Post("/login", controller.AccountLogin)
	account.Post("/register", controller.AccountRegister)
}
