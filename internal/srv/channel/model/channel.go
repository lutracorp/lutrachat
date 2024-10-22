package model

// GetParams represents params of get endpoint.
type GetParams struct {
	ChannelID string `params:"channel_id"` // Represents requested channel id.
}

// CreateSchema represents body of channel create request.
type CreateSchema struct {
	Type       uint8    `json:"type"`       // The type of the channel.
	Name       string   `json:"name"`       // The name of the channel.
	Recipients []string `json:"recipients"` // The users to add in the channel.
}
