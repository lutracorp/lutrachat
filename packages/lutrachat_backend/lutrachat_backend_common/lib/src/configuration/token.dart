import 'package:freezed_annotation/freezed_annotation.dart';

import 'codec.dart';

part 'token.freezed.dart';
part 'token.g.dart';

/// Token related configuration.
@freezed
sealed class TokenConfiguration with _$TokenConfiguration {
  const factory TokenConfiguration({
    /// Codec configuration.
    required CodecConfiguration codec,
  }) = _TokenConfiguration;

  factory TokenConfiguration.fromJson(Map<String, dynamic> json) =>
      _$TokenConfigurationFromJson(json);
}
