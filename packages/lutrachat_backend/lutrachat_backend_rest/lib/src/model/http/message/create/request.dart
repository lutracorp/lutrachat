import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:luthor/luthor.dart';

part 'request.freezed.dart';
part 'request.g.dart';

@freezed
interface class MessageCreateRequest with _$MessageCreateRequest {
  static final Validator schema = l.schema({
    'content': l.string().min(1).max(2000).required(),
  });

  const factory MessageCreateRequest({
    /// The content of the message.
    required String content,
  }) = _MessageCreateRequest;

  static SchemaValidationResult validate(Map<String, Object?> json) =>
      schema.validateSchema(
        json,
        fromJson: MessageCreateRequest.fromJson,
      );

  factory MessageCreateRequest.fromJson(Map<String, Object?> json) =>
      _$MessageCreateRequestFromJson(json);
}
