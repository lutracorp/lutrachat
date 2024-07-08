import 'dart:async';

import 'package:shelf_plus/shelf_plus.dart';

import '../structure/base/route.dart';

/// A service that provides an HTTP server.
abstract interface class ServerService {
  /// Mount route to the server.
  Future<void> mountRoute(ServerRoute route);

  /// Launches the HTTP server.
  Future<void> listen();
}
