import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:lutrachat_common/lutrachat_common.dart';
import 'package:prometheus_client/format.dart';
import 'package:prometheus_client/prometheus_client.dart';
import 'package:shelf_plus/shelf_plus.dart';

import '../metrics.dart';

@LazySingleton(as: MetricsController)
final class MetricsControllerImplementation implements MetricsController {
  /// Service for registering and collecting metrics.
  final MetricsService metricsService;

  MetricsControllerImplementation(this.metricsService);

  @override
  Future<Response> collect(Request request) async {
    final StringBuffer stringBuffer = StringBuffer();

    await metricsService.collect().then(
      (Iterable<MetricFamilySamples> metricFamilySamples) {
        write004(stringBuffer, metricFamilySamples);
      },
    );

    return Response.ok('$stringBuffer', headers: {
      HttpHeaders.contentTypeHeader: contentType,
    });
  }
}
