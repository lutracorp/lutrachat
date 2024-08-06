import 'package:foxid/foxid.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:luthor/luthor.dart';

part 'query.freezed.dart';
part 'query.g.dart';

@freezed
interface class MessageListQuery with _$MessageListQuery {
  const factory MessageListQuery({
    ///	Max number of messages to return.
    int? limit,

    /// Get messages before this message ID.
    FOxID? before,

    /// Get messages after this message ID.
    FOxID? after,
  }) = _MessageListQuery;

  factory MessageListQuery.fromJson(Map<String, Object?> json) =>
      _$MessageListQueryFromJson(json);
}
