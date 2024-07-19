import 'package:dartfield/dartfield.dart';
import 'package:foxid/foxid.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lutrachat_backend_database/lutrachat_backend_database.dart';

part 'response.freezed.dart';
part 'response.g.dart';

@freezed
interface class ChannelResponse with _$ChannelResponse {
  const factory ChannelResponse({
    /// The ID of the channel.
    required FOxID id,

    /// The type of the channel.
    required ChannelType type,

    /// The flags of the channel.
    required BitField flags,

    /// The name of the channel.
    String? name,
  }) = _ChannelResponse;

  factory ChannelResponse.fromJson(Map<String, Object?> json) =>
      _$ChannelResponseFromJson(json);

  factory ChannelResponse.fromTableData(ChannelTableData data) =>
      ChannelResponse(
        id: data.id,
        type: data.type,
        flags: data.flags,
        name: data.name,
      );
}
