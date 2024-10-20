package token

import (
	"bytes"
	"encoding/hex"

	"github.com/lutracorp/lutrachat/api/protocol/pkg/token/v1"
	"golang.org/x/crypto/poly1305"
	"google.golang.org/protobuf/proto"
	"google.golang.org/protobuf/types/known/timestamppb"
)

// Handler contains data required to manipulate with tokens.
type Handler struct {
	cfg *Config // Config of token handler.

	secret []byte // Decoded secret used to derive token signing keys.
}

// NewHandler creates new token handler.
func NewHandler(cfg *Config) (*Handler, error) {
	secret, err := hex.DecodeString(cfg.Secret)
	if err != nil {
		return nil, err
	}

	return &Handler{
		cfg:    cfg,
		secret: secret,
	}, nil
}

// DeriveKey combines payload with secret.
func (h *Handler) DeriveKey(payload []byte) [32]byte {
	var key [32]byte
	copy(key[:], payload)

	sl := len(h.secret)
	for i := range len(key) {
		key[i] ^= h.secret[i%sl]
	}

	return key
}

// ComputeSignature computes signature of passed TokenData using given secret.
func (h *Handler) ComputeSignature(data *v1.TokenData, secret []byte) ([]byte, error) {
	key := h.DeriveKey(secret)

	td := proto.Clone(data).(*v1.TokenData)
	td.Signature = nil

	mrs, err := proto.Marshal(td)
	if err != nil {
		return nil, err
	}

	var sign [16]byte
	poly1305.Sum(&sign, mrs, &key)

	return sign[:], nil
}

// Sign signs payload with secret and returns TokenData.
func (h *Handler) Sign(payload []byte, secret []byte) (*v1.TokenData, error) {
	data := &v1.TokenData{
		Payload:   payload,
		Timestamp: timestamppb.Now(),
	}

	var err error
	data.Signature, err = h.ComputeSignature(data, secret)
	if err != nil {
		return nil, err
	}

	return data, nil
}

// Verify verifies signed token data for validity.
func (h *Handler) Verify(data *v1.TokenData, secret []byte) (bool, error) {
	sign, err := h.ComputeSignature(data, secret)
	if err != nil {
		return false, err
	}

	return bytes.Equal(data.Signature, sign), nil
}
