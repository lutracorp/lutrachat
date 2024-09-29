package server

// ErrorKind represents kind of error.
type ErrorKind uint32

// Kinds of errors.
const (
	GeneralErrorKind          ErrorKind = iota // GeneralErrorKind represents general errors.
	ValidationErrorKind                        // ValidationErrorKind represents validation errors.
	DisallowedActionErrorKind                  // DisallowedActionErrorKind represents errors for disallowed actions.
)

// ErrorCode represents error code.
type ErrorCode uint32

const (
	UnknownGeneralErrorCode ErrorCode = iota // UnknownGeneralErrorCode represents unknown GeneralErrorKind error.
)

const (
	MalformedBodyValidationErrorCode ErrorCode = iota + 1 // MalformedBodyValidationErrorCode represents malformed request body error.
)

const (
	ConflictDisallowedActionErrorCode     ErrorCode = iota + 1 // ConflictDisallowedActionErrorCode means that the request data is in conflict with data that already exists.
	UnauthorizedDisallowedActionErrorCode                      // UnauthorizedDisallowedActionErrorCode means that authorization error occurred processing request.
)
