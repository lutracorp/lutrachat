package model

// RegisterSchema represents body of authentication register request.
type RegisterSchema struct {
	Name     string `json:"name"`     // The user's name.
	Email    string `json:"email"`    // The user's email address.
	Password string `json:"password"` // The user's password.
}

// LoginSchema represents body of authentication login request.
type LoginSchema struct {
	Email    string `json:"email"`    // The user's email address.
	Password string `json:"password"` // The user's password.
}

// TokenResponse contains authentication token.
type TokenResponse struct {
	Token string `json:"token"` // Authentication token itself.
}
