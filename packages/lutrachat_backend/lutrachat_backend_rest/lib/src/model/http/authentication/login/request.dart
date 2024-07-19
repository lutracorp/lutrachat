import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:luthor/luthor.dart';

part 'request.freezed.dart';
part 'request.g.dart';

@luthor
@freezed
interface class AuthenticationLoginRequest with _$AuthenticationLoginRequest {
  const factory AuthenticationLoginRequest({
    /// The user's email address.
    @HasMin(4) @HasMax(256) required String email,

    /// The user's password.
    @HasMin(8) @HasMax(72) required String password,
  }) = _AuthenticationLoginRequest;

  static SchemaValidationResult<AuthenticationLoginRequest> validate(
    Map<String, dynamic> json,
  ) =>
      $AuthenticationLoginRequestValidate(json);

  factory AuthenticationLoginRequest.fromJson(Map<String, Object?> json) =>
      _$AuthenticationLoginRequestFromJson(json);
}
