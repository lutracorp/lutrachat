package token

import (
	"bytes"
	"encoding/base64"
	"github.com/lutracorp/lutrachat/api/protocol/struct/v1"
	"golang.org/x/crypto/poly1305"
	"google.golang.org/protobuf/proto"
	"google.golang.org/protobuf/types/known/timestamppb"
)

// derive returns signature of given payload.
func derive(payload []byte, secret []byte) []byte {
	var (
		key  [32]byte
		sign [16]byte
	)
	copy(key[:], secret)

	poly1305.Sum(&sign, payload, &key)

	return sign[:]
}

// Sign returns signed token data.
func Sign(payload []byte, secret []byte) (*v1.TokenData, error) {
	data := v1.TokenData{
		Payload:   payload,
		Timestamp: timestamppb.Now(),
	}

	pm, err := proto.Marshal(&data)
	if err != nil {
		return nil, err
	}

	data.Signature = derive(pm, secret)

	return &data, nil
}

// Verify checks whether the token data valid.
func Verify(data *v1.TokenData, secret []byte) (bool, error) {
	td := proto.Clone(data).(*v1.TokenData)
	td.Signature = nil

	pm, err := proto.Marshal(td)
	if err != nil {
		return false, err
	}

	sign := derive(pm, secret)

	return bytes.Equal(data.Signature, sign), nil
}

// Marshal returns the string encoded version of src.
func Marshal(src *v1.TokenData) (string, error) {
	pm, err := proto.Marshal(src)
	if err != nil {
		return "", err
	}

	return base64.URLEncoding.EncodeToString(pm), nil
}

// Unmarshal parses string in src and writes result in dst.
func Unmarshal(src string, dst *v1.TokenData) error {
	str, err := base64.URLEncoding.DecodeString(src)
	if err != nil {
		return err
	}

	return proto.Unmarshal(str, dst)
}
