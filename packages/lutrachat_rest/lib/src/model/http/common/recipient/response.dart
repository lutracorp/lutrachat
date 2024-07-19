import 'package:foxid/foxid.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lutrachat_database/lutrachat_database.dart';

part 'response.freezed.dart';
part 'response.g.dart';

@freezed
interface class RecipientResponse with _$RecipientResponse {
  const factory RecipientResponse({
    /// The ID of the channel participant.
    required FOxID id,

    /// The channel itself in which the user participates.
    required FOxID channel,

    /// A user participating in a channel.
    required FOxID user,
  }) = _RecipientResponse;

  factory RecipientResponse.fromJson(Map<String, Object?> json) =>
      _$RecipientResponseFromJson(json);

  factory RecipientResponse.fromTableData(RecipientTableData data) =>
      RecipientResponse(
        id: data.id,
        channel: data.channel,
        user: data.user,
      );
}
