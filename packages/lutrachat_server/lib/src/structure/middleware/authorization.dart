import 'dart:io';

import 'package:foxid/foxid.dart';
import 'package:injectable/injectable.dart';
import 'package:lutrachat_common/lutrachat_common.dart';
import 'package:lutrachat_database/lutrachat_database.dart';
import 'package:shelf_plus/shelf_plus.dart';

import '../../enumerable/error/authorization.dart';
import '../base/error.dart';
import '../base/middleware.dart';

/// Middleware to verify authorization token.
@lazySingleton
final class AuthorizationMiddleware extends ServerMiddleware {
  /// A service for signing and verifying tokens.
  final TokenService tokenService;

  /// Data accessor for the user table.
  final UserAccessor userAccessor;

  AuthorizationMiddleware(this.tokenService, this.userAccessor);

  @override
  Handler call(Handler innerHandler) {
    return (Request request) async {
      final String? token = request.headers[HttpHeaders.authorizationHeader];

      if (token != null) {
        final TokenData tokenData = tokenService.decode(token);
        final FOxID userId = FOxID.fromList(tokenData.payload);
        final UserTableData? user = await userAccessor.findById(userId);

        if (user != null) {
          final bool isTokenValid =
              await tokenService.verify(token, user.passwordHash);

          if (isTokenValid) {
            return innerHandler(
              request.change(context: {
                'lutrachat/user': user,
                ...request.context,
              }),
            );
          }
        }
      }

      throw ServerError(AuthorizationErrorCode.invalidToken);
    };
  }
}
