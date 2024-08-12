import 'package:injectable/injectable.dart';
import 'package:lutrachat_backend_common/lutrachat_backend_common.dart';
import 'package:prometheus_client/prometheus_client.dart';
import 'package:shelf_plus/shelf_plus.dart';

import '../base/middleware.dart';

/// Middleware for collecting metrics.
@lazySingleton
final class MetricsMiddleware extends ServerMiddleware {
  /// Rules to escape URIs in metrics.
  static final Map<RegExp, String> uriEscapeRules = {
    RegExp(r'[0-9A-HJKMNP-TV-Z]{26}'): ':id'
  };

  /// Service for registering and collecting metrics
  final MetricsService metricsService;

  /// Metric containing requests count.
  final Counter requestCount = Counter(
    name: 'http_server_request_count',
    help: 'Number of Requests',
    labelNames: const ['method', 'path', 'status'],
  );

  /// Metrics containing requests duration.
  final Histogram requestDuration = Histogram(
    name: 'http_server_request_duration',
    help: 'Duration of Requests',
    labelNames: const ['method', 'path', 'status'],
  );

  MetricsMiddleware(this.metricsService) {
    metricsService
      ..register(requestCount)
      ..register(requestDuration);
  }

  /// Removes sensitive information from [Uri]
  static Uri escapeUri(Uri uri) {
    uriEscapeRules.forEach(
      (RegExp rule, String replacer) => uri = uri.replace(
        path: uri.path.replaceAll(rule, replacer),
      ),
    );

    return uri;
  }

  @override
  Handler call(Handler innerHandler) {
    return (Request request) async {
      final Stopwatch watch = Stopwatch();
      Response? response;

      try {
        watch.start();

        return response = await innerHandler(request);
      } finally {
        watch.stop();

        if (response != null && response.statusCode == 200) {
          final List<String> labels = [
            request.method,
            escapeUri(request.requestedUri).path,
            '${response.statusCode}',
          ];

          requestCount.labels(labels).inc();
          requestDuration.labels(labels).observe(
              watch.elapsedMicroseconds / Duration.microsecondsPerSecond);
        }
      }
    };
  }
}
