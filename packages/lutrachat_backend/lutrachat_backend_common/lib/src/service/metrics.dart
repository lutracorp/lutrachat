import 'package:prometheus_client/prometheus_client.dart';

/// Service for registering and collecting metrics.
abstract interface class MetricsService {
  /// Registers a metrics collector.
  void register(Collector collector);

  /// Collect all metrics and samples.
  Future<Iterable<MetricFamilySamples>> collect();
}
