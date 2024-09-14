package model

// RegisterPayload represents body of authentication register request.
type RegisterPayload struct {
	Name     string `json:"name"`     // The user's name.
	Email    string `json:"email"`    // The user's email address.
	Password string `json:"password"` // The user's password.
}

// LoginPayload represents body of authentication login request.
type LoginPayload struct {
	Email    string `json:"email"`    // The user's email address.
	Password string `json:"password"` // The user's password.
}

// TokenResponse contains authentication token.
type TokenResponse struct {
	Token string `json:"token"` // Authentication token itself.
}
