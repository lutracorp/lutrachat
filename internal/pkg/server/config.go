package server

// Config represents server configuration.
type Config struct {
	Address string `hcl:"address"` // The address to bind the server.
	Port    uint16 `hcl:"port"`    // The port to bind the server.
}
