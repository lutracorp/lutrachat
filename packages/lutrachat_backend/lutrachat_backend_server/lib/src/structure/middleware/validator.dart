import 'package:injectable/injectable.dart';
import 'package:luthor/luthor.dart';
import 'package:shelf_plus/shelf_plus.dart';

import '../../enumerable/error/common.dart';
import '../../extension/request/context.dart';
import '../base/error.dart';
import '../base/middleware.dart';

typedef SchemaValidator = SchemaValidationResult Function(Map<String, Object?>);

/// Middleware for validating requests.
@lazySingleton
final class ValidatorMiddleware extends ServerMiddleware {
  Middleware body(SchemaValidator validator) {
    return (Handler innerHandler) {
      return (Request request) async {
        final Map<String, Object?> body = await request.body.asJson;
        final SchemaValidationResult result = validator(body);

        switch (result) {
          case SchemaValidationSuccess():
            return await innerHandler(request.change(context: {
              ...request.context,
              RequestContext.validationResultKey: result,
            }));
          case SchemaValidationError():
            throw ServerError(CommonErrorCode.malformedRequest);
        }
      };
    };
  }

  @override
  @Deprecated('Use ValidatorMiddleware.body instead.')
  Handler call(Handler innerHandler) {
    throw UnimplementedError();
  }
}
