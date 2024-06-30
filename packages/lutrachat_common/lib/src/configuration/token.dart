import 'dart:convert';

import 'package:base_codecs/base_codecs.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'token.freezed.dart';
part 'token.g.dart';

/// Token related configuration.
@freezed
sealed class TokenConfiguration with _$TokenConfiguration {
  const TokenConfiguration._();

  /// A Base16 (Hex, RFC 4648) token codec.
  const factory TokenConfiguration.base16() = _TokenConfigurationBase16;

  /// A Base32 Crockford token codec.
  const factory TokenConfiguration.base32() = _TokenConfigurationBase32;

  /// A Base58 BitCoin token codec.
  const factory TokenConfiguration.base58() = _TokenConfigurationBase58;

  /// A Base64 Url-Safe token codec.
  const factory TokenConfiguration.base64() = _TokenConfigurationBase64;

  /// Get a codec instance based on this configuration.
  Codec<List<int>, String> get codec => switch (this) {
        _TokenConfigurationBase16() => base16,
        _TokenConfigurationBase32() => base32Crockford,
        _TokenConfigurationBase58() => base58Bitcoin,
        _TokenConfigurationBase64() => base64Url,
      };

  factory TokenConfiguration.fromJson(Map<String, dynamic> json) =>
      _$TokenConfigurationFromJson(json);
}
