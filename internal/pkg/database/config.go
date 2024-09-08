package database

// Config represents database connection configuration.
type Config struct {
	Type string `hcl:"type,label"` // Database type.
	DSN  string `hcl:"dsn"`        // Database connection URI.
}
