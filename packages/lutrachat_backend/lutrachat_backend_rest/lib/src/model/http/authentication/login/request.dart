import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:luthor/luthor.dart';

part 'request.freezed.dart';
part 'request.g.dart';

@freezed
interface class AuthenticationLoginRequest with _$AuthenticationLoginRequest {
  static final Validator schema = l.schema({
    'email': l.string().min(4).max(256).email().required(),
    'password': l.string().min(8).max(72).required(),
  });

  const factory AuthenticationLoginRequest({
    /// The user's email address.
    required String email,

    /// The user's password.
    required String password,
  }) = _AuthenticationLoginRequest;

  static SchemaValidationResult validate(Map<String, Object?> json) =>
      schema.validateSchema(
        json,
        fromJson: AuthenticationLoginRequest.fromJson,
      );

  factory AuthenticationLoginRequest.fromJson(Map<String, Object?> json) =>
      _$AuthenticationLoginRequestFromJson(json);
}
