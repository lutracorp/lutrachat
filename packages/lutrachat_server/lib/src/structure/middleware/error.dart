import 'package:injectable/injectable.dart';
import 'package:shelf_plus/shelf_plus.dart';

import '../../model/error/response.dart';
import '../base/error.dart';
import '../base/middleware.dart';

/// Middleware for handling errors.
@lazySingleton
final class ErrorMiddleware extends ServerMiddleware {
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
      } catch (_) {
        return Response.internalServerError();
      }
    };
  }
}
