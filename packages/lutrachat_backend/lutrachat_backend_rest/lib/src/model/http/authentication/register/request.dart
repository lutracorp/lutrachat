import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:luthor/luthor.dart';

part 'request.freezed.dart';
part 'request.g.dart';

@freezed
interface class AuthenticationRegisterRequest
    with _$AuthenticationRegisterRequest {
  static final Validator schema = l.schema({
    'email': l.string().min(4).max(256).email().required(),
    'password': l.string().min(8).max(72).required(),
    'name': l.string().min(2).max(32).required(),
  });

  const factory AuthenticationRegisterRequest({
    /// The user's email address.
    required String email,

    /// The user's password.
    required String password,

    /// The user's name.
    required String name,
  }) = _AuthenticationRegisterRequest;

  static SchemaValidationResult validate(Map<String, Object?> json) =>
      schema.validateSchema(
        json,
        fromJson: AuthenticationRegisterRequest.fromJson,
      );

  factory AuthenticationRegisterRequest.fromJson(Map<String, Object?> json) =>
      _$AuthenticationRegisterRequestFromJson(json);
}
