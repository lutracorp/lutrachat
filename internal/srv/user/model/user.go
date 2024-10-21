package model

// GetParams represents params of get endpoint.
type GetParams struct {
	UserID string `params:"user_id"` // Represents requested user id.
}
