import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:luthor/luthor.dart';

part 'request.freezed.dart';
part 'request.g.dart';

@luthor
@freezed
interface class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    /// The user's email address.
    @HasMin(4) @HasMax(256) required String email,

    /// The user's password.
    @HasMin(8) @HasMax(72) required String password,
  }) = _LoginRequest;

  static SchemaValidationResult<LoginRequest> validate(
    Map<String, dynamic> json,
  ) =>
      $LoginRequestValidate(json);

  factory LoginRequest.fromJson(Map<String, Object?> json) =>
      _$LoginRequestFromJson(json);
}