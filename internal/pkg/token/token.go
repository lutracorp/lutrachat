package token

import (
	tokpb "github.com/lutracorp/lutrachat/api/protocol/pkg/token/v1"
)

var handler *Handler

// Initialize creates handler used to manipulate tokens.
func Initialize(cfg *Config) error {
	var err error
	handler, err = NewHandler(cfg)

	return err
}

// Sign signs payload with secret and returns TokenData.
func Sign(payload []byte, secret []byte) (*tokpb.TokenData, error) {
	return handler.Sign(payload, secret)
}

// Verify verifies signed token data for validity.
func Verify(data *tokpb.TokenData, secret []byte) (bool, error) {
	return handler.Verify(data, secret)
}
