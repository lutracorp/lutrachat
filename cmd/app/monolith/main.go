package main

import (
	"github.com/hashicorp/hcl/v2/hclsimple"
	"github.com/lutracorp/lutrachat/internal/pkg/database"
	"github.com/lutracorp/lutrachat/internal/pkg/server/http"
	"github.com/lutracorp/lutrachat/internal/pkg/token"
	"github.com/lutracorp/lutrachat/internal/srv/authentication"
	"github.com/lutracorp/lutrachat/internal/srv/channel"
	"github.com/lutracorp/lutrachat/internal/srv/identity"
	"github.com/lutracorp/lutrachat/internal/srv/user"
)

func main() {
	var cfg authentication.Config
	if err := hclsimple.DecodeFile("config.hcl", nil, &cfg); err != nil {
		panic(err)
	}

	if err := database.Connect(&cfg.Database); err != nil {
		panic(err)
	}

	if err := database.Migrate(&database.User{}, &database.Channel{}, &database.Message{}, &database.Recipient{}); err != nil {
		panic(err)
	}

	if err := token.Initialize(&cfg.Token); err != nil {
		panic(err)
	}

	http.Use(user.Route, channel.Route, identity.Route, authentication.Route)
	if err := http.Listen(&cfg.Http); err != nil {
		panic(err)
	}
}
