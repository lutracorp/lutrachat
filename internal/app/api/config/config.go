package config

import (
	"github.com/lutracorp/lutrachat/internal/pkg/database"
	"github.com/lutracorp/lutrachat/internal/pkg/server"
)

// Config represents API configuration.
type Config struct {
	Http     server.Config   `hcl:"http,block"`     // Server listener configuration.
	Database database.Config `hcl:"database,block"` // Database connection configuration.
}
