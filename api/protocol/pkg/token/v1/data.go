package v1

import (
	"encoding/base64"

	"google.golang.org/protobuf/proto"
)

// Marshal encodes token data to strings.
func Marshal(data *TokenData) (string, error) {
	pm, err := proto.Marshal(data)
	if err != nil {
		return "", err
	}

	return base64.URLEncoding.EncodeToString(pm), nil
}

// Unmarshal decodes given string to token data.
func Unmarshal(src string, dst *TokenData) error {
	str, err := base64.URLEncoding.DecodeString(src)
	if err != nil {
		return err
	}

	return proto.Unmarshal(str, dst)
}
