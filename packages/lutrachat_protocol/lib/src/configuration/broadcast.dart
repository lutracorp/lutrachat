import 'package:freezed_annotation/freezed_annotation.dart';

import '../structure/base/broadcast.dart';
import '../structure/broadcast/local.dart';

part 'broadcast.freezed.dart';
part 'broadcast.g.dart';

/// Broadcast related configuration.
@freezed
sealed class BroadcastConfiguration with _$BroadcastConfiguration {
  const BroadcastConfiguration._();

  /// A broadcast running in a local stream.
  const factory BroadcastConfiguration.local() = _BroadcastConfigurationLocal;

  /// Get a Broadcast instance based on this configuration.
  Broadcast get instance => switch (this) {
        _BroadcastConfigurationLocal() => LocalBroadcast(),
      };

  factory BroadcastConfiguration.fromJson(Map<String, dynamic> json) =>
      _$BroadcastConfigurationFromJson(json);
}
