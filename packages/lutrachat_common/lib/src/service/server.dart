import 'dart:async';

import 'package:shelf_plus/shelf_plus.dart';

/// A service that provides an HTTP server.
abstract interface class ServerService {
  /// A router that forwards requests to handlers.
  RouterPlus get router;

  /// Launches the HTTP server.
  Future<void> listen();
}
