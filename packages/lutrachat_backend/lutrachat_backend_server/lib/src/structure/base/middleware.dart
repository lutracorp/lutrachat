import 'package:shelf_plus/shelf_plus.dart';

/// An interface that represents a server middleware.
abstract base class ServerMiddleware {
  /// Internal logic of middleware.
  Handler call(Handler innerHandler);
}
