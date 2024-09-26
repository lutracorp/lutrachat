package grpc

import (
	"fmt"
	"net"

	"github.com/lutracorp/lutrachat/internal/pkg/server"
	"google.golang.org/grpc"
)

// Delegate provides capability to execute function with server as argument.
type Delegate = func(*grpc.Server)

var srv = grpc.NewServer()

// Listen binds server according to passed configuration.
func Listen(config *server.Config) error {
	addr := fmt.Sprintf("%s:%d", config.Address, config.Port)

	list, err := net.Listen("tcp", addr)
	if err != nil {
		return err
	}

	return srv.Serve(list)
}

// Use runs delegate on the server.
func Use(delegate ...Delegate) {
	for _, delegate := range delegate {
		delegate(srv)
	}
}

// Close shutdown's server.
func Close() error {
	srv.Stop()

	return nil
}
