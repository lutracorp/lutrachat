import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:luthor/luthor.dart';

part 'request.freezed.dart';
part 'request.g.dart';

@luthor
@freezed
interface class MessageCreateRequest with _$MessageCreateRequest {
  const factory MessageCreateRequest({
    @HasMax(2000) required String content,
  }) = _MessageCreateRequest;

  static SchemaValidationResult<MessageCreateRequest> validate(
    Map<String, dynamic> json,
  ) =>
      $MessageCreateRequestValidate(json);

  factory MessageCreateRequest.fromJson(Map<String, Object?> json) =>
      _$MessageCreateRequestFromJson(json);
}
