package server

// ErrorKind represents kind of error.
type ErrorKind uint32

// Contains kinds of errors.
const (
	// GeneralErrorKind represents general errors.
	GeneralErrorKind ErrorKind = iota
)

// ErrorCode represents error code.
type ErrorCode uint32

// General kind errors.
const (
	// UnknownErrorCode represents error code for unknown errors.
	UnknownErrorCode ErrorCode = iota
)
