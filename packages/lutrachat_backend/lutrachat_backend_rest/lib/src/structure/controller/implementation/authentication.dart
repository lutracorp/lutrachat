import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:lutrachat_backend_common/lutrachat_backend_common.dart';
import 'package:lutrachat_backend_database/lutrachat_backend_database.dart';
import 'package:lutrachat_backend_server/lutrachat_backend_server.dart';
import 'package:shelf_plus/shelf_plus.dart';

import '../../../model/http/common/token/response.dart';
import '../../../model/http/authentication/login/request.dart';
import '../../../model/http/authentication/register/request.dart';
import '../authentication.dart';

@LazySingleton(as: AuthenticationController)
final class AuthenticationControllerImplementation
    implements AuthenticationController {
  /// A service that provides an HTTP server.
  final ServerService serverService;

  /// A service that provides logging capability.
  final LoggerService loggerService;

  /// The service that provides the KDF.
  final KDFService kdfService;

  /// A service for signing and verifying tokens.
  final TokenService tokenService;

  /// Data accessor for the user table.
  final UserAccessor userAccessor;

  AuthenticationControllerImplementation(
    this.serverService,
    this.loggerService,
    this.kdfService,
    this.tokenService,
    this.userAccessor,
  );

  @override
  Future<AuthenticationTokenResponse> register(Request request) async {
    final AuthenticationRegisterRequest registerPayload =
        await request.body.as(AuthenticationRegisterRequest.fromJson);

    final Uint8List passwordHash =
        await kdfService.derivePasswordBytes(registerPayload.password);

    final UserTableData? user = await userAccessor.insertOneOrIgnore(
      UserTableCompanion.insert(
        name: registerPayload.name,
        email: registerPayload.email,
        passwordHash: passwordHash,
      ),
    );

    if (user != null) {
      final String token = await tokenService.sign(
        user.id.payload,
        user.passwordHash,
      );

      return AuthenticationTokenResponse(token: token);
    }

    throw ServerError(AuthenticationErrorCode.credentialsAlreadyTaken);
  }

  @override
  Future<AuthenticationTokenResponse> login(Request request) async {
    final AuthenticationLoginRequest loginPayload =
        await request.body.as(AuthenticationLoginRequest.fromJson);

    final UserTableData? user =
        await userAccessor.findOneByEmail(loginPayload.email);

    if (user != null) {
      final bool isPasswordValid = await kdfService.verifyPasswordBytes(
        loginPayload.password,
        user.passwordHash,
      );

      if (isPasswordValid) {
        final String token = await tokenService.sign(
          user.id.payload,
          user.passwordHash,
        );

        return AuthenticationTokenResponse(token: token);
      }
    }

    throw ServerError(AuthenticationErrorCode.invalidCredentials);
  }
}
