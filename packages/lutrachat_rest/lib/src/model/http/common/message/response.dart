import 'package:dartfield/dartfield.dart';
import 'package:foxid/foxid.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lutrachat_database/lutrachat_database.dart';

part 'response.freezed.dart';
part 'response.g.dart';

@freezed
interface class MessageResponse with _$MessageResponse {
  const factory MessageResponse({
    /// The ID of the message.
    required FOxID id,

    /// The ID of the channel the message was sent in.
    required FOxID channel,

    /// The author of the message.
    required FOxID author,

    /// Contents of the message.
    required String content,

    ///	The type of message.
    required MessageType type,

    /// The flags of message.
    required BitField flags,
  }) = _MessageResponse;

  factory MessageResponse.fromJson(Map<String, Object?> json) =>
      _$MessageResponseFromJson(json);

  factory MessageResponse.fromTableData(MessageTableData data) =>
      MessageResponse(
        id: data.id,
        channel: data.channel,
        author: data.author,
        content: data.content,
        type: data.type,
        flags: data.flags,
      );
}
