import 'dart:async';

import 'package:shelf_plus/shelf_plus.dart';

/// An interface that represents a server route.
abstract base class ServerRoute {
  /// Route prefix.
  String get prefix;

  /// Function to configure the request handler.
  FutureOr<Handler> configure();
}
