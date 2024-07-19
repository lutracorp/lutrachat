import 'package:shelf_plus/shelf_plus.dart';

/// A controller that performs metrics collection.
abstract interface class MetricsController {
  /// Returns collected metrics.
  Future<Response> collect(Request request);
}
