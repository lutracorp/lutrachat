package token

// Config represents token configuration.
type Config struct {
	Secret string `hcl:"secret"` // Secret contains secret used to derive token signing keys.
}
