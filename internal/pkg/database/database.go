package database

import (
	"errors"

	"gorm.io/driver/mysql"
	"gorm.io/driver/postgres"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
)

// DB stores database definition.
var DB *gorm.DB

// newDialector creates database dialector for further use.
func newDialector(config *Config) (gorm.Dialector, error) {
	switch config.Type {
	case "postgres":
		return postgres.Open(config.DSN), nil
	case "sqlite":
		return sqlite.Open(config.DSN), nil
	case "mysql":
		return mysql.Open(config.DSN), nil
	default:
		return nil, errors.New("unsupported database type")
	}
}

// Connect connects to database.
func Connect(config *Config) error {
	dial, err := newDialector(config)
	if err != nil {
		return err
	}

	DB, err = gorm.Open(dial)
	return err
}

// Migrate automatically migrates database schema.
func Migrate(models ...interface{}) error {
	return DB.AutoMigrate(models...)
}

// Disconnect disconnects gorm from database.
func Disconnect() error {
	sqlDB, err := DB.DB()
	if err != nil {
		return err
	}

	return sqlDB.Close()
}
