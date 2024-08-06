import 'package:foxid/foxid.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lutrachat_backend_database/lutrachat_backend_database.dart';

part 'request.freezed.dart';
part 'request.g.dart';

sealed class ChannelCreateRequest {
  const ChannelCreateRequest._();

  const factory ChannelCreateRequest.notes() = _NotesChannelCreateRequest;

  const factory ChannelCreateRequest.direct({
    /// The user to include in the direct channel.
    required FOxID recipient,
  }) = _DirectChannelCreateRequest;

  const factory ChannelCreateRequest.group({
    /// The name of the group.
    String? name,

    /// The users to include in the group channel.
    Set<FOxID>? recipients,
  }) = _GroupChannelCreateRequest;

  factory ChannelCreateRequest.fromJson(Map<String, Object?> json) {
    final int typeIndex = json['type'] as int;
    final ChannelType type = ChannelType.fromIndex(typeIndex);

    switch (type) {
      case ChannelType.notes:
        return _$NotesChannelCreateRequestFromJson(json);
      case ChannelType.direct:
        return _$DirectChannelCreateRequestFromJson(json);
      case ChannelType.group:
        return _$GroupChannelCreateRequestFromJson(json);
    }
  }
}

@freezed
interface class NotesChannelCreateRequest extends ChannelCreateRequest
    with _$NotesChannelCreateRequest {
  @Implements<ChannelCreateRequest>()
  const factory NotesChannelCreateRequest() = _NotesChannelCreateRequest;

  factory NotesChannelCreateRequest.fromJson(Map<String, Object?> json) =>
      _$NotesChannelCreateRequestFromJson(json);
}

@freezed
interface class DirectChannelCreateRequest extends ChannelCreateRequest
    with _$DirectChannelCreateRequest {
  @Implements<ChannelCreateRequest>()
  const factory DirectChannelCreateRequest({
    /// The user to include in the direct channel.
    required FOxID recipient,
  }) = _DirectChannelCreateRequest;

  factory DirectChannelCreateRequest.fromJson(Map<String, Object?> json) =>
      _$DirectChannelCreateRequestFromJson(json);
}

@freezed
interface class GroupChannelCreateRequest extends ChannelCreateRequest
    with _$GroupChannelCreateRequest {
  @Implements<ChannelCreateRequest>()
  const factory GroupChannelCreateRequest({
    /// The name of the group.
    String? name,

    /// The users to include in the group channel.
    Set<FOxID>? recipients,
  }) = _GroupChannelCreateRequest;

  factory GroupChannelCreateRequest.fromJson(Map<String, Object?> json) =>
      _$GroupChannelCreateRequestFromJson(json);
}
