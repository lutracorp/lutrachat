import 'package:freezed_annotation/freezed_annotation.dart';

import 'broadcast.dart';

part 'pubsub.freezed.dart';
part 'pubsub.g.dart';

/// PubSub related configuration.
@freezed
sealed class PubSubConfiguration with _$PubSubConfiguration {
  const factory PubSubConfiguration({
    /// Broadcast related configuration.
    required BroadcastConfiguration broadcast,
  }) = _PubSubConfiguration;

  factory PubSubConfiguration.fromJson(Map<String, dynamic> json) =>
      _$PubSubConfigurationFromJson(json);
}
