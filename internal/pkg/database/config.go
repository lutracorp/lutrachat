package database

// Config represents database connection configuration.
type Config struct {
	/// Type represents database type to connect for.
	Type string `hcl:"type,label"`

	/// DSN represents database connection string.
	DSN string `hcl:"dsn"`
}
