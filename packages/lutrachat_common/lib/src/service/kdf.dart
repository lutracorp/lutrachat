import 'dart:typed_data';

import '../../gen/proto/service/kdf/v1/result.pb.dart';

/// The service that provides the KDF.
abstract interface class KDFService {
  /// Derive a key based on the input data.
  Future<KDFResult> derive(Uint8List payload);

  /// Derive a key bytes based on the input data.
  Future<Uint8List> deriveBytes(Uint8List payload);

  /// Derive a key based on the password.
  Future<KDFResult> derivePassword(String password);

  /// Derive a key bytes based on the password.
  Future<Uint8List> derivePasswordBytes(String password);

  /// Checking whether the input data corresponds to the expected result.
  Future<bool> verify(Uint8List payload, KDFResult expected);

  /// Checking whether the input data corresponds to the expected result in bytes.
  Future<bool> verifyBytes(Uint8List payload, Uint8List expected);

  /// Check if the password matches the expected result.
  Future<bool> verifyPassword(String password, KDFResult expected);

  /// Check if the password matches the expected result in bytes.
  Future<bool> verifyPasswordBytes(String password, Uint8List expected);
}
