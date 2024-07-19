import 'package:freezed_annotation/freezed_annotation.dart';

part 'response.freezed.dart';
part 'response.g.dart';

@freezed
interface class AuthenticationTokenResponse with _$AuthenticationTokenResponse {
  const factory AuthenticationTokenResponse({
    /// The authentication token.
    required String token,
  }) = _AuthenticationTokenResponse;

  factory AuthenticationTokenResponse.fromJson(Map<String, Object?> json) =>
      _$AuthenticationTokenResponseFromJson(json);
}
