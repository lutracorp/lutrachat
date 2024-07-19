import 'package:injectable/injectable.dart';
import 'package:prometheus_client/prometheus_client.dart';

import '../logger.dart';
import '../metrics.dart';

@LazySingleton(as: MetricsService)
final class MetricServiceImplementation implements MetricsService {
  /// Registry of metrics collectors.
  final CollectorRegistry collectorRegistry = CollectorRegistry.defaultRegistry;

  /// A service that provides logging capability.
  final LoggerService loggerService;

  MetricServiceImplementation(this.loggerService);

  @override
  void register(Collector collector) {
    try {
      collectorRegistry.register(collector);
    } on ArgumentError catch (error, stackTrace) {
      loggerService.warn('Collector already registered.', error, stackTrace);
    }
  }

  @override
  Future<Iterable<MetricFamilySamples>> collect() async {
    return await collectorRegistry.collectMetricFamilySamples();
  }
}
