package config

import (
	"github.com/lutracorp/lutrachat/internal/pkg/database"
	"github.com/lutracorp/lutrachat/internal/pkg/server"
)

// Config represents API configuration.
type Config struct {
	Server   server.Config   `hcl:"server,block"`   // Server listener configuration.
	Database database.Config `hcl:"database,block"` // Database connection configuration.
}
