import 'package:injectable/injectable.dart';
import 'package:lutrachat_backend_server/lutrachat_backend_server.dart';
import 'package:shelf_plus/shelf_plus.dart';

import '../../model/http/authentication/login/request.dart';
import '../../model/http/authentication/register/request.dart';
import '../controller/authentication.dart';

/// A route that handles user authentication.
@LazySingleton(as: ServerRoute)
final class AuthenticationRoute extends ServerRoute {
  @override
  final String prefix = '/authentication';

  /// Middleware for validating requests.
  final ValidatorMiddleware validatorMiddleware;

  /// A controller that performs user authentication.
  final AuthenticationController authenticationController;

  AuthenticationRoute(this.validatorMiddleware, this.authenticationController);

  @override
  Handler configure() => RouterPlus()
    ..post(
      '/login',
      authenticationController.login,
      use: validatorMiddleware.body(AuthenticationLoginRequest.validate),
    )
    ..post(
      '/register',
      authenticationController.register,
      use: validatorMiddleware.body(AuthenticationRegisterRequest.validate),
    );
}
