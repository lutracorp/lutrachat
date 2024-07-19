import 'package:injectable/injectable.dart';
import 'package:shelf_plus/shelf_plus.dart';

import '../base/route.dart';
import '../controller/metrics.dart';

/// A route that handles metrics collection.
@LazySingleton(as: ServerRoute)
final class MetricsRoute extends ServerRoute {
  @override
  final String prefix = '/metrics';

  /// A controller that performs metrics collection.
  final MetricsController metricsController;

  MetricsRoute(this.metricsController);

  @override
  Handler configure() => metricsController.collect;
}
