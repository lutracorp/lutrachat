import 'package:freezed_annotation/freezed_annotation.dart';

part 'response.freezed.dart';
part 'response.g.dart';

@freezed
interface class ErrorResponse with _$ErrorResponse {
  const factory ErrorResponse({
    /// Code of the error.
    required int code,

    /// Kind of the error.
    required String kind,
  }) = _ErrorResponse;

  factory ErrorResponse.fromJson(Map<String, Object?> json) =>
      _$ErrorResponseFromJson(json);
}
