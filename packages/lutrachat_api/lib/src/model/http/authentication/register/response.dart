import 'package:freezed_annotation/freezed_annotation.dart';

part 'response.freezed.dart';
part 'response.g.dart';

@freezed
interface class RegisterResponse with _$RegisterResponse {
  const factory RegisterResponse({
    /// The authentication token.
    required String token,
  }) = _RegisterResponse;

  factory RegisterResponse.fromJson(Map<String, Object?> json) =>
      _$RegisterResponseFromJson(json);
}
