package database

type (
	// User is a model representing the user in the database.
	User struct {
		ID       string `gorm:"primaryKey"` // Identifier of the User in the database.
		Type     uint8  // The type of the user.
		Name     string `gorm:"uniqueIndex"` // The user's name.
		Email    string `gorm:"uniqueIndex"` // The user's email address.
		Flags    uint32 // The flags of the user.
		Password []byte // A result of kdf on the user's password.
	}

	// Channel is a model representing the channel in the database.
	Channel struct {
		ID    string `gorm:"primaryKey"` // Identifier of the Channel in the database.
		Type  uint8  // The type of the channel.
		Name  string // The channel's name.
		Flags uint32 // The flags of the channel.
	}

	// Recipient is a model representing the recipient in the database.
	Recipient struct {
		ID        string `gorm:"primaryKey"`          // Identifier of the Recipient in the database.
		UserID    string `gorm:"index:idx_recipient"` // Identifier of the User that participate in Channel.
		ChannelID string `gorm:"index:idx_recipient"` // Identifier of the Channel in which Recipient participate.

		User    User    `gorm:"foreignKey:UserID;references:ID"`    // User that participate in Channel.
		Channel Channel `gorm:"foreignKey:ChannelID;references:ID"` // Channel in which Recipient participate.
	}

	// Message is a model representing the message in the database.
	Message struct {
		ID        string `gorm:"primaryKey"` // Identifier of the message.
		Type      uint8  // The type of the message.
		Flags     uint32 // The flags of the channel.
		Content   []byte // The content of the message.
		AuthorID  string // Identifier of the Author of the message.
		ChannelID string // Identifier of the Channel in which message was sent.

		Author  User    `gorm:"foreignKey:AuthorID;references:ID"`  // Author of the message.
		Channel Channel `gorm:"foreignKey:ChannelID;references:ID"` // Channel in which message was sent.
	}
)
