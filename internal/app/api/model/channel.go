package model

// ChannelCreateSchema represents body of channel create request.
type ChannelCreateSchema struct {
	Type       uint8    `json:"type"`       // The type of the channel.
	Name       string   `json:"name"`       // The name of the channel.
	Recipients []string `json:"recipients"` // The users to add in the channel.
}
