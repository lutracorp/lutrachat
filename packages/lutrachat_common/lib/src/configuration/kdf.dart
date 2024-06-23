import 'package:cryptography/cryptography.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'kdf.freezed.dart';
part 'kdf.g.dart';

/// KDF related configuration.
@freezed
sealed class KDFConfiguration with _$KDFConfiguration {
  const KDFConfiguration._();

  /// Argon2id (RFC 9106) memory-hard password hashing function.
  const factory KDFConfiguration.argon2id({
    /// The number of 1 kB memory blocks required to compute the hash.
    @Default(19000) int memory,

    /// The maximum number of parallel computations.
    @Default(1) int parallelism,

    /// The number of iterations.
    @Default(2) int iterations,

    /// The length of hash.
    @Default(32) int hashLength,
  }) = KDFConfigurationArgon2id;

  /// Get a KDF instance based on this configuration.
  KdfAlgorithm get algorithm => switch (this) {
        KDFConfigurationArgon2id(
          :final parallelism,
          :final memory,
          :final iterations,
          :final hashLength
        ) =>
          Argon2id(
            parallelism: parallelism,
            memory: memory,
            iterations: iterations,
            hashLength: hashLength,
          ),
      };

  factory KDFConfiguration.fromJson(Map<String, dynamic> json) =>
      _$KDFConfigurationFromJson(json);
}
