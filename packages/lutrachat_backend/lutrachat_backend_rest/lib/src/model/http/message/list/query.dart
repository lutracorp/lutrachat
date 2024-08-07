import 'package:foxid/foxid.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:luthor/luthor.dart';

part 'query.freezed.dart';
part 'query.g.dart';

@freezed
interface class MessageListQuery with _$MessageListQuery {
  static final Validator schema = l.schema({
    'limit': l.int().min(1).max(50),
    'before': l.string().regex(r'[0-9A-HJKMNP-TV-Z]{26}'),
    'after': l.string().regex(r'[0-9A-HJKMNP-TV-Z]{26}'),
  });

  const factory MessageListQuery({
    ///	Max number of messages to return.
    int? limit,

    /// Get messages before this message ID.
    FOxID? before,

    /// Get messages after this message ID.
    FOxID? after,
  }) = _MessageListQuery;

  static SchemaValidationResult validate(Map<String, Object?> json) =>
      schema.validateSchema(
        json,
        fromJson: MessageListQuery.fromJson,
      );

  factory MessageListQuery.fromJson(Map<String, Object?> json) =>
      _$MessageListQueryFromJson(json);
}
