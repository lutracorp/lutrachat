import 'dart:async';

import '../structure/base/route.dart';

/// A service that provides an HTTP server.
abstract interface class ServerService {
  /// Mount route to the server.
  Future<void> mount(ServerRoute route);

  /// Launches the HTTP server.
  Future<void> listen();
}
