package kdf

import (
	"bytes"
	"crypto/rand"
	"github.com/lutracorp/lutrachat/api/protocol/struct/v1"
	"golang.org/x/crypto/argon2"
)

// GenerateSalt returns the generated salt of the specified length.
func GenerateSalt(length uint) ([]byte, error) {
	salt := make([]byte, length)

	if _, err := rand.Read(salt); err != nil {
		return nil, err
	}

	return salt, nil
}

// Derive returns the KDF result from the input data.
func Derive(input []byte) (*v1.KdfResult, error) {
	nonce, err := GenerateSalt(32)
	if err != nil {
		return nil, err
	}

	key := argon2.Key(input, nonce, 3, 32*1024, 4, 32)

	return &v1.KdfResult{
		Key:   key,
		Nonce: nonce,
	}, nil
}

// Verify checks whether the input data matches the expected output.
func Verify(input []byte, expected *v1.KdfResult) bool {
	key := argon2.Key(input, expected.Nonce, 3, 32*1024, 4, 32)

	return bytes.Equal(key, expected.Key)
}
