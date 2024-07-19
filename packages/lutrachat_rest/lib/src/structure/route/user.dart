import 'package:injectable/injectable.dart';
import 'package:lutrachat_server/lutrachat_server.dart';
import 'package:shelf_plus/shelf_plus.dart';

import '../controller/user.dart';

/// A route that handles user actions.
@LazySingleton(as: ServerRoute)
final class UserRoute extends ServerRoute {
  @override
  final String prefix = '/users';

  /// Middleware to verify authorization token.
  final AuthorizationMiddleware authorizationMiddleware;

  /// A controller that performs user actions.
  final UserController userController;

  UserRoute(this.authorizationMiddleware, this.userController);

  @override
  Handler configure() => RouterPlus()
    ..get(
      '/@me',
      userController.self,
      use: authorizationMiddleware,
    )
    ..get(
      '/<user>',
      userController.fetch,
      use: authorizationMiddleware,
    );
}
