import 'package:injectable/injectable.dart';
import 'package:lutrachat_backend_common/lutrachat_backend_common.dart';
import 'package:shelf_plus/shelf_plus.dart';

import '../../model/http/error/response.dart';
import '../base/error.dart';
import '../base/middleware.dart';

/// Middleware for handling errors.
@lazySingleton
final class ErrorMiddleware extends ServerMiddleware {
  /// A service that provides logging capability.
  final LoggerService loggerService;

  ErrorMiddleware(this.loggerService);

  @override
  Handler call(Handler innerHandler) {
    return (Request request) async {
      try {
        return await innerHandler(request);
      } catch (error, stackTrace) {
        if (error is! ServerError) {
          loggerService.error('Error during request.', error, stackTrace);
        }

        return resolveResponse(
          request,
          ErrorResponse.fromError(error),
        );
      }
    };
  }
}
