import 'package:dartfield/dartfield.dart';
import 'package:foxid/foxid.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lutrachat_database/lutrachat_database.dart';

part 'response.freezed.dart';
part 'response.g.dart';

@freezed
interface class ChannelFetchResponse with _$ChannelFetchResponse {
  const factory ChannelFetchResponse({
    /// The ID of the channel.
    required FOxID id,

    /// The type of the channel.
    required ChannelType type,

    /// The flags of the channel.
    required BitField flags,

    /// The name of the channel.
    String? name,
  }) = _ChannelFetchResponse;

  factory ChannelFetchResponse.fromJson(Map<String, Object?> json) =>
      _$ChannelFetchResponseFromJson(json);

  factory ChannelFetchResponse.fromTableData(ChannelTableData data) =>
      ChannelFetchResponse(
        id: data.id,
        type: data.type,
        flags: data.flags,
        name: data.name,
      );
}
