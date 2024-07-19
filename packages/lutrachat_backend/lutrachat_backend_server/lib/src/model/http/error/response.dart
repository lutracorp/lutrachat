import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../structure/base/error.dart';

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

  factory ErrorResponse.fromError(Object error) {
    if (error is ServerError) {
      return ErrorResponse(code: error.code, kind: error.kind);
    }

    return ErrorResponse(code: -1, kind: 'INTERNAL_ERROR');
  }
}
