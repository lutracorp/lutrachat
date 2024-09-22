package model

// MessageListQuery contains search query for message list endpoint.
type MessageListQuery struct {
	Type   *uint8 `query:"type"`
	Limit  uint8  `query:"limit"`
	After  string `query:"after"`
	Before string `query:"before"`
}

// MessageCreateSchema contains data requited to post message in channel.
type MessageCreateSchema struct {
	Type    uint8  `json:"type"`
	Content []byte `json:"content"`
}
