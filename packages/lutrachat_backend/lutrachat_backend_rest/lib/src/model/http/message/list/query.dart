import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:luthor/luthor.dart';

part 'query.freezed.dart';
part 'query.g.dart';

@luthor
@freezed
interface class MessageListQuery with _$MessageListQuery {
  const factory MessageListQuery({
    ///	Max number of messages to return.
    @HasMax(100) int? limit,

    /// Get messages before this message ID.
    @HasLength(26) String? before,

    /// Get messages after this message ID.
    @HasLength(26) String? after,
  }) = _MessageListQuery;

  static SchemaValidationResult<MessageListQuery> validate(
    Map<String, dynamic> json,
  ) =>
      $MessageListQueryValidate(json);

  factory MessageListQuery.fromJson(Map<String, Object?> json) =>
      _$MessageListQueryFromJson(json);
}
