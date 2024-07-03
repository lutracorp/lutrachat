import 'dart:typed_data';

import 'package:dartfield/dartfield.dart';
import 'package:injectable/injectable.dart';
import 'package:lutrachat_common/lutrachat_common.dart';
import 'package:lutrachat_database/lutrachat_database.dart';
import 'package:shelf_plus/shelf_plus.dart';

import '../../../model/http/authentication/login/request.dart';
import '../../../model/http/authentication/login/response.dart';
import '../../../model/http/authentication/register/request.dart';
import '../../../model/http/authentication/register/response.dart';
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
  Future<RegisterResponse> register(Request request) async {
    final RegisterRequest registerPayload =
        await request.body.as(RegisterRequest.fromJson);

    final Uint8List passwordHash =
        await kdfService.derivePasswordBytes(registerPayload.password);

    final UserTableData? user = await userAccessor.insertOrIgnore(
      UserTableCompanion.insert(
        name: registerPayload.name,
        email: registerPayload.email,
        passwordHash: passwordHash,
        flags: BitField.empty(),
      ),
    );

    if (user != null) {
      final String token = await tokenService.sign(
        user.id.payload,
        user.passwordHash,
      );

      return RegisterResponse(token: token);
    } else {
      throw GenericError(AuthenticationError.credentialsAlreadyTaken);
    }
  }

  @override
  Future<LoginResponse> login(Request request) async {
    final LoginRequest loginPayload =
        await request.body.as(LoginRequest.fromJson);

    final UserTableData? user =
        await userAccessor.findByEmail(loginPayload.email);

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

        return LoginResponse(token: token);
      }
    }

    throw GenericError(AuthenticationError.invalidCredentials);
  }

  /// Mounts controller to HTTP server.
  @postConstruct
  void mount() {
    loggerService.trace('Mounting authentication controller');

    serverService.router.mount(
      '/authentication',
      RouterPlus()
        ..post('/login', login)
        ..post('/register', register),
    );
  }
}
