package authentication

import (
	"github.com/lutracorp/lutrachat/internal/pkg/database"
	"github.com/lutracorp/lutrachat/internal/pkg/server"
	"github.com/lutracorp/lutrachat/internal/pkg/token"
)

// Config represents service configuration.
type Config struct {
	Http     server.Config   `hcl:"http,block"`     // Http represents http server configuration.
	Token    token.Config    `hcl:"token,block"`    // Token represents token handler configuration.
	Database database.Config `hcl:"database,block"` // Database represents database connection configuration.
}
