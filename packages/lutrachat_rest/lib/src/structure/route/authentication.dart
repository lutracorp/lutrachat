import 'package:injectable/injectable.dart';
import 'package:lutrachat_server/lutrachat_server.dart';
import 'package:shelf_plus/shelf_plus.dart';

import '../controller/authentication.dart';

/// A route that handles user authentication.
@LazySingleton(as: ServerRoute)
final class AuthenticationRoute extends ServerRoute {
  @override
  final String prefix = '/authentication';

  /// A controller that performs user authentication.
  final AuthenticationController authenticationController;

  AuthenticationRoute(this.authenticationController);

  @override
  Handler configure() => RouterPlus()
    ..post('/login', authenticationController.login)
    ..post('/register', authenticationController.register);
}
