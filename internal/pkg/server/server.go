package server

import (
	"fmt"
	"github.com/goccy/go-json"
	"github.com/gofiber/fiber/v2"
)

// Delegate provides capability to execute function with server as argument.
type Delegate = func(*fiber.App) error

const appName = "LutraChat"

var srv = fiber.New(
	fiber.Config{
		AppName:      appName,
		JSONEncoder:  json.Marshal,
		JSONDecoder:  json.Unmarshal,
		ServerHeader: appName,
		ErrorHandler: nil,
		Prefork:      true,
	},
)

// Listen binds server according to passed configuration.
func Listen(config *Config) error {
	address := fmt.Sprintf("%s:%d", config.Address, config.Port)

	return srv.Listen(address)
}

// Use runs delegate on a server.
func Use(delegate ...Delegate) error {
	for _, delegate := range delegate {
		if err := delegate(srv); err != nil {
			return err
		}
	}

	return nil
}

// Close shutdown's server.
func Close() error {
	return srv.Shutdown()
}
