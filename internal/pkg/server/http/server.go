package http

import (
	"errors"
	"fmt"

	"github.com/goccy/go-json"
	"github.com/gofiber/fiber/v2"
	"github.com/lutracorp/lutrachat/internal/pkg/server"
)

// Delegate provides capability to execute function with server as argument.
type Delegate = func(*fiber.App)

const appName = "LutraChat"

var srv = fiber.New(
	fiber.Config{
		AppName:      appName,
		JSONEncoder:  json.Marshal,
		JSONDecoder:  json.Unmarshal,
		ServerHeader: appName,
		ErrorHandler: errorHandler,
	},
)

// errorHandler executed when handler returns error.
func errorHandler(ctx *fiber.Ctx, err error) error {
	var e *Error
	if !errors.As(err, &e) {
		e = GeneralError
	}

	return ctx.Status(e.Status).JSON(e)
}

// Listen binds server according to passed configuration.
func Listen(config *server.Config) error {
	address := fmt.Sprintf("%s:%d", config.Address, config.Port)

	return srv.Listen(address)
}

// Use runs delegate on the server.
func Use(delegate ...Delegate) {
	for _, delegate := range delegate {
		delegate(srv)
	}
}

// Close shutdown's server.
func Close() error {
	return srv.Shutdown()
}
