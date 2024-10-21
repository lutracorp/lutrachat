package user

import (
	"github.com/lutracorp/lutrachat/internal/pkg/database"
	"github.com/lutracorp/lutrachat/internal/pkg/server"
)

// Config represents service configuration.
type Config struct {
	Http     server.Config   `hcl:"http,block"`     // Http represents http server configuration.
	Database database.Config `hcl:"database,block"` // Database represents database connection configuration.
}
