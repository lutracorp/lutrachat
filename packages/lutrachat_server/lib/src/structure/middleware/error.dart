import 'package:injectable/injectable.dart';
import 'package:lutrachat_common/lutrachat_common.dart';
import 'package:shelf_plus/shelf_plus.dart';

import '../../model/error/response.dart';
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
      } on ServerError catch (error) {
        return resolveResponse(
          request,
          ErrorResponse(code: error.code, kind: error.kind),
        );
      } catch (error, stackTrace) {
        loggerService.error('Error during request.', error, stackTrace);

        return Response.internalServerError();
      }
    };
  }
}
