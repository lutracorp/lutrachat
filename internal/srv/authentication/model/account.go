package model

// TokenResponse represents token response.
type TokenResponse struct {
	Token string `json:"token"` // Token contained in response.
}

// AccountLoginSchema represents account login request body.
type AccountLoginSchema struct {
	Email    string `json:"email"`    // The user's email.
	Password string `json:"password"` // The user's password.
}

// AccountRegisterSchema represents account register request body.
type AccountRegisterSchema struct {
	Name     string `json:"name"`     // The user's name.
	Email    string `json:"email"`    // The user's email.
	Password string `json:"password"` // The user's password.
}
