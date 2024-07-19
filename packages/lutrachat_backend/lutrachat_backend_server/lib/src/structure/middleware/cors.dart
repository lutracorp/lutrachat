import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:shelf_plus/shelf_plus.dart';

import '../base/middleware.dart';

/// Middleware for providing CORS support.
@lazySingleton
final class CorsMiddleware extends ServerMiddleware {
  /// Allowed CORS methods.
  static const List<String> allowMethods = [
    'GET',
    'POST',
    'PUT',
    'DELETE',
    'OPTIONS',
    'PATCH'
  ];

  /// Allowed CORS headers.
  static const List<String> allowHeaders = [
    HttpHeaders.acceptHeader,
    HttpHeaders.acceptEncodingHeader,
    HttpHeaders.authorizationHeader,
    HttpHeaders.contentTypeHeader,
    HttpHeaders.userAgentHeader,
  ];

  /// Headers to make CORS work.
  static const Map<String, Object> corsHeaders = {
    HttpHeaders.accessControlAllowOriginHeader: '*',
    HttpHeaders.accessControlAllowMethodsHeader: allowMethods,
    HttpHeaders.accessControlAllowHeadersHeader: allowHeaders,
    HttpHeaders.accessControlMaxAgeHeader: '86400',
  };

  @override
  Handler call(Handler innerHandler) {
    return (Request request) async {
      if (request.method == 'OPTIONS') {
        return Response.ok(null, headers: corsHeaders);
      }

      final Response response = await innerHandler(request);

      return response.change(headers: {
        ...response.headers,
        ...corsHeaders,
      });
    };
  }
}
