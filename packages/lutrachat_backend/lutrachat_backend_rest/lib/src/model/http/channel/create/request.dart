import 'package:foxid/foxid.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:luthor/luthor.dart';
import 'package:lutrachat_backend_database/lutrachat_backend_database.dart';

part 'request.freezed.dart';
part 'request.g.dart';

sealed class ChannelCreateRequest {
  static final Validator schema = l.schema({
    'type': l.int().min(0).max(2).required(),
  });

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

  static SchemaValidationResult validate(Map<String, Object?> json) {
    final SchemaValidationResult rootResult = schema.validateSchema(json);

    switch (rootResult) {
      case SchemaValidationSuccess():
        final int typeIndex = json['type'] as int;
        final ChannelType type = ChannelType.fromIndex(typeIndex);

        switch (type) {
          case ChannelType.notes:
            return NotesChannelCreateRequest.validate(json);
          case ChannelType.direct:
            return DirectChannelCreateRequest.validate(json);
          case ChannelType.group:
            return GroupChannelCreateRequest.validate(json);
        }
      case SchemaValidationError():
        return rootResult;
    }
  }

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
  static final Validator schema = l.schema({});

  @Implements<ChannelCreateRequest>()
  const factory NotesChannelCreateRequest() = _NotesChannelCreateRequest;

  static SchemaValidationResult<NotesChannelCreateRequest> validate(
    Map<String, Object?> json,
  ) =>
      schema.validateSchema(
        json,
        fromJson: NotesChannelCreateRequest.fromJson,
      );

  factory NotesChannelCreateRequest.fromJson(Map<String, Object?> json) =>
      _$NotesChannelCreateRequestFromJson(json);
}

@freezed
interface class DirectChannelCreateRequest extends ChannelCreateRequest
    with _$DirectChannelCreateRequest {
  static final Validator schema = l.schema({
    'recipient': l.string().regex(r'[0-9A-HJKMNP-TV-Z]{26}').required(),
  });

  @Implements<ChannelCreateRequest>()
  const factory DirectChannelCreateRequest({
    /// The user to include in the direct channel.
    required FOxID recipient,
  }) = _DirectChannelCreateRequest;

  static SchemaValidationResult<DirectChannelCreateRequest> validate(
    Map<String, Object?> json,
  ) =>
      schema.validateSchema(
        json,
        fromJson: DirectChannelCreateRequest.fromJson,
      );

  factory DirectChannelCreateRequest.fromJson(Map<String, Object?> json) =>
      _$DirectChannelCreateRequestFromJson(json);
}

@freezed
interface class GroupChannelCreateRequest extends ChannelCreateRequest
    with _$GroupChannelCreateRequest {
  static final Validator schema = l.schema({
    'name': l.string().min(1).max(32),
    'recipients': l.list(validators: [
      l.string().regex(r'[0-9A-HJKMNP-TV-Z]{26}'),
    ])
  });

  @Implements<ChannelCreateRequest>()
  const factory GroupChannelCreateRequest({
    /// The name of the group.
    String? name,

    /// The users to include in the group channel.
    Set<FOxID>? recipients,
  }) = _GroupChannelCreateRequest;

  static SchemaValidationResult<GroupChannelCreateRequest> validate(
    Map<String, Object?> json,
  ) =>
      schema.validateSchema(
        json,
        fromJson: GroupChannelCreateRequest.fromJson,
      );

  factory GroupChannelCreateRequest.fromJson(Map<String, Object?> json) =>
      _$GroupChannelCreateRequestFromJson(json);
}
