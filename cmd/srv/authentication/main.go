package main

import (
	"github.com/hashicorp/hcl/v2/hclsimple"
	"github.com/lutracorp/lutrachat/internal/app/api/config"
	"github.com/lutracorp/lutrachat/internal/pkg/database"
	"github.com/lutracorp/lutrachat/internal/pkg/server/http"
	"github.com/lutracorp/lutrachat/internal/srv/authentication"
)

func main() {
	var cfg config.Config
	if err := hclsimple.DecodeFile("config.hcl", nil, &cfg); err != nil {
		panic(err)
	}

	if err := database.Connect(&cfg.Database); err != nil {
		panic(err)
	}

	if err := database.Migrate(&database.User{}); err != nil {
		panic(err)
	}

	http.Use(authentication.Route)
	if err := http.Listen(&cfg.Http); err != nil {
		panic(err)
	}
}
