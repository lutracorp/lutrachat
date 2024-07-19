import 'dart:convert';

import 'package:base_codecs/base_codecs.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'codec.freezed.dart';
part 'codec.g.dart';

/// Codec related configuration.
@freezed
sealed class CodecConfiguration with _$CodecConfiguration {
  const CodecConfiguration._();

  /// A Base16 (Hex, RFC 4648) codec.
  const factory CodecConfiguration.base16() = _CodecConfigurationBase16;

  /// A Base32 Crockford codec.
  const factory CodecConfiguration.base32() = _CodecConfigurationBase32;

  /// A Base58 BitCoin codec.
  const factory CodecConfiguration.base58() = _CodecConfigurationBase58;

  /// A Base64 Url-Safe codec.
  const factory CodecConfiguration.base64() = _CodecConfigurationBase64;

  /// Get a codec instance based on this configuration.
  Codec<List<int>, String> get instance => switch (this) {
        _CodecConfigurationBase16() => base16,
        _CodecConfigurationBase32() => base32Crockford,
        _CodecConfigurationBase58() => base58Bitcoin,
        _CodecConfigurationBase64() => base64Url,
      };

  factory CodecConfiguration.fromJson(Map<String, dynamic> json) =>
      _$CodecConfigurationFromJson(json);
}
