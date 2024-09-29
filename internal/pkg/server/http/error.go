package http

import (
	"fmt"

	"github.com/lutracorp/lutrachat/internal/pkg/server"
)

// Error represents http server error.
type Error struct {
	Kind server.ErrorKind `json:"kind"` // Kind represents kind of error.
	Code server.ErrorCode `json:"code"` // Code represents error code.
}

func (e *Error) Error() string {
	return fmt.Sprintf("%d: %d", e.Code, e.Kind)
}

// NewHTTPError creates new HTTPError object.
func NewHTTPError(kind server.ErrorKind, code server.ErrorCode) *Error {
	return &Error{kind, code}
}
