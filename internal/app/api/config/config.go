package config

import "github.com/lutracorp/lutrachat/internal/pkg/database"

// Config represents API configuration.
type Config struct {
	// Database connection configuration.
	Database database.Config `hcl:"database,block"`
}
