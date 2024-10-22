package http

import (
	"fmt"

	"github.com/gofiber/fiber/v2"
)

type (
	ErrorKind uint16 // ErrorKind represents kind of error.
	ErrorCode uint16 // ErrorCode represents code of error.
)

// Error represents http server error.
type Error struct {
	Kind ErrorKind `json:"kind"` // Kind specifies kind of error.
	Code ErrorCode `json:"code"` // Code specifies code of error.

	Status int `json:"-"` // Status specifies HTTP status code to respond.
}

// Error returns string representation of error.
func (e *Error) Error() string {
	return fmt.Sprintf("%d: %d", e.Code, e.Kind)
}

// NewError creates new Error object.
func NewError(kind ErrorKind, code ErrorCode, status int) *Error {
	return &Error{kind, code, status}
}

const (
	generalErrorKind     ErrorKind = iota // General errors.
	validationErrorKind                   // Validation related errors.
	limitationErrorKind                   // Resource limitation errors.
	restrictionErrorKind                  // Access restriction errors.
	unknownErrorKind                      // Unknown resource errors.
)

const (
	generalErrorCode ErrorCode = iota // Any error don't covered with errors below.
)

const (
	malformedRequestValidationErrorCode ErrorCode = iota + 1 // Malformed request body received.
)

const (
	credentialsAlreadyUsedLimitationCode ErrorCode = iota + 1 // User with these credentials already exists.
)

const (
	invalidCredentialsRestrictionErrorCode ErrorCode = iota + 1 // Invalid credentials passed.
)

const (
	userUnknownErrorCode    ErrorCode = iota + 1 // Indicates that's requested user doesn't exist.
	channelUnknownErrorCode                      // Indicates that's requested channel doesn't exist.
)

// GeneralError represents errors such as an internal server error.
var GeneralError = NewError(generalErrorKind, generalErrorCode, fiber.StatusTeapot)

// MalformedRequestValidationError means that the server received request data that it cannot understand.
var MalformedRequestValidationError = NewError(validationErrorKind, malformedRequestValidationErrorCode, fiber.StatusBadRequest)

// CredentialsAlreadyUsedLimitationError means that someone has already registered using these credentials.
var CredentialsAlreadyUsedLimitationError = NewError(limitationErrorKind, credentialsAlreadyUsedLimitationCode, fiber.StatusConflict)

// InvalidCredentialsRestrictionError means that you passed incorrect credentials.
var InvalidCredentialsRestrictionError = NewError(restrictionErrorKind, invalidCredentialsRestrictionErrorCode, fiber.StatusUnauthorized)

var (
	UserUnknownError    = NewError(unknownErrorKind, userUnknownErrorCode, fiber.StatusNotFound)    // UserUnknownError means that you requested user that don't exist.
	ChannelUnknownError = NewError(unknownErrorKind, channelUnknownErrorCode, fiber.StatusNotFound) // ChannelUnknownError means that you requested channel that don't exist.
)
