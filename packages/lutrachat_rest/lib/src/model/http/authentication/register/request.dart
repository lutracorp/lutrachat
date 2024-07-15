import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:luthor/luthor.dart';

part 'request.freezed.dart';
part 'request.g.dart';

@luthor
@freezed
interface class AuthenticationRegisterRequest
    with _$AuthenticationRegisterRequest {
  const factory AuthenticationRegisterRequest({
    /// The user's email address.
    @HasMin(4) @HasMax(256) required String email,

    /// The user's password.
    @HasMin(8) @HasMax(72) required String password,

    /// The user's name.
    @HasMin(2) @HasMax(32) required String name,
  }) = _AuthenticationRegisterRequest;

  static SchemaValidationResult<AuthenticationRegisterRequest> validate(
    Map<String, dynamic> json,
  ) =>
      $AuthenticationRegisterRequestValidate(json);

  factory AuthenticationRegisterRequest.fromJson(Map<String, Object?> json) =>
      _$AuthenticationRegisterRequestFromJson(json);
}
