package route

import (
	"github.com/gofiber/fiber/v2"
	"github.com/lutracorp/lutrachat/internal/app/api/controller"
	"github.com/lutracorp/lutrachat/internal/app/api/middleware"
)

// UserRoute binds user related routes to server.
func UserRoute(srv *fiber.App) error {
	group := srv.Group("/users", middleware.Authorization)

	group.Get("/@me", controller.UserGetCurrent)
	group.Get("/:user", controller.UserGet)

	return nil
}
