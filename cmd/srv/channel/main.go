package main

import (
	"github.com/hashicorp/hcl/v2/hclsimple"
	"github.com/lutracorp/lutrachat/internal/pkg/database"
	"github.com/lutracorp/lutrachat/internal/pkg/server/http"
	"github.com/lutracorp/lutrachat/internal/srv/channel"
)

func main() {
	var cfg channel.Config
	if err := hclsimple.DecodeFile("config.hcl", nil, &cfg); err != nil {
		panic(err)
	}

	if err := database.Connect(&cfg.Database); err != nil {
		panic(err)
	}

	if err := database.Migrate(&database.User{}); err != nil {
		panic(err)
	}

	http.Use(channel.Route)
	if err := http.Listen(&cfg.Http); err != nil {
		panic(err)
	}
}
