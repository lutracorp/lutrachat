package model

// AuthenticationRegisterSchema represents body of authentication register request.
type AuthenticationRegisterSchema struct {
	Name     string `json:"name"`     // The user's name.
	Email    string `json:"email"`    // The user's email address.
	Password string `json:"password"` // The user's password.
}

// AuthenticationLoginSchema represents body of authentication login request.
type AuthenticationLoginSchema struct {
	Email    string `json:"email"`    // The user's email address.
	Password string `json:"password"` // The user's password.
}

// AuthenticationTokenResponse contains authentication token.
type AuthenticationTokenResponse struct {
	Token string `json:"token"` // Authentication token itself.
}
