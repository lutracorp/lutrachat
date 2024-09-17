package database

type (
	// User is a model representing the user in the database.
	User struct {
		ID       string `json:"id" gorm:"primaryKey"`     // Identifier of the User in the database.
		Type     uint8  `json:"type"`                     // The type of the user.
		Name     string `json:"name" gorm:"uniqueIndex"`  // The user's name.
		Email    string `json:"email" gorm:"uniqueIndex"` // The user's email address.
		Flags    uint32 `json:"flags"`                    // The flags of the user.
		Password []byte `json:"-"`                        // A result of kdf on the user's password.
	}

	// Channel is a model representing the channel in the database.
	Channel struct {
		ID    string `json:"id" gorm:"primaryKey"` // Identifier of the Channel in the database.
		Type  uint8  `json:"type"`                 // The type of the channel.
		Name  string `json:"name"`                 // The channel's name.
		Flags uint32 `json:"flags"`                // The flags of the channel.
	}

	// Recipient is a model representing the recipient in the database.
	Recipient struct {
		ID        string `json:"id" gorm:"primaryKey"`               // Identifier of the Recipient in the database.
		UserID    string `json:"user" gorm:"index:idx_recipient"`    // Identifier of the User that participate in Channel.
		ChannelID string `json:"channel" gorm:"index:idx_recipient"` // Identifier of the Channel in which Recipient participate.

		User    User    `json:"-" gorm:"foreignKey:UserID;references:ID"`    // User that participate in Channel.
		Channel Channel `json:"-" gorm:"foreignKey:ChannelID;references:ID"` // Channel in which Recipient participate.
	}

	// Message is a model representing the message in the database.
	Message struct {
		ID        string `json:"id" gorm:"primaryKey"` // Identifier of the message.
		Type      uint8  `json:"type"`                 // The type of the message.
		Flags     uint32 `json:"flags"`                // The flags of the channel.
		Content   []byte `json:"content"`              // The content of the message.
		AuthorID  string `json:"author"`               // Identifier of the Author of the message.
		ChannelID string `json:"channel"`              // Identifier of the Channel in which message was sent.

		Author  User    `json:"-" gorm:"foreignKey:AuthorID;references:ID"`  // Author of the message.
		Channel Channel `json:"-" gorm:"foreignKey:ChannelID;references:ID"` // Channel in which message was sent.
	}
)
