import 'package:freezed_annotation/freezed_annotation.dart';

part 'response.freezed.dart';
part 'response.g.dart';

@freezed
interface class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    /// The authentication token.
    required String token,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, Object?> json) =>
      _$LoginResponseFromJson(json);
}
