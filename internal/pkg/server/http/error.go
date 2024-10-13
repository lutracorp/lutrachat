package http

import (
	"fmt"
)

type (
	ErrorKind uint16 // ErrorKind represents kind of error.
	ErrorCode uint16 // ErrorCode represents code of error.
)

// Error represents http server error.
type Error struct {
	Kind ErrorKind `json:"kind"` // Kind specifies kind of error.
	Code ErrorCode `json:"code"` // Code specifies code of error.
}

// Error returns string representation of error.
func (e *Error) Error() string {
	return fmt.Sprintf("%d: %d", e.Code, e.Kind)
}

// NewError creates new Error object.
func NewError(kind ErrorKind, code ErrorCode) *Error {
	return &Error{kind, code}
}

const (
	validationErrorKind  ErrorKind = iota + 1 // Validation related errors.
	limitationErrorKind                       // Resource limitation errors.
	restrictionErrorKind                      // Access restriction errors.
)

const (
	malformedBodyValidationErrorCode ErrorCode = iota + 1 // Malformed request body received.
)

const (
	credentialsAlreadyUsedLimitationCode ErrorCode = iota + 1 // User with these credentials already exists.
)

const (
	invalidCredentialsRestrictionErrorCode ErrorCode = iota + 1 // Invalid credentials passed.
)

// GeneralError represents errors such as an internal server error.
var GeneralError = NewError(0, 0)

// MalformedBodyValidationError means that the server received data that it cannot understand.
var MalformedBodyValidationError = NewError(validationErrorKind, malformedBodyValidationErrorCode)

// CredentialsAlreadyUsedLimitationError means that someone has already registered using these credentials.
var CredentialsAlreadyUsedLimitationError = NewError(limitationErrorKind, credentialsAlreadyUsedLimitationCode)

// InvalidCredentialsRestrictionError means that you passed incorrect credentials.
var InvalidCredentialsRestrictionError = NewError(restrictionErrorKind, invalidCredentialsRestrictionErrorCode)
