import 'dart:typed_data';

import '../../gen/proto/service/kdf/v1/result.pb.dart';

/// The service that provides the KDF.
abstract interface class KDFService {
  /// Derive a key based on the input data.
  Future<KDFResult> derive(Uint8List payload);

  /// Derive a key based on the password.
  Future<KDFResult> derivePassword(String password);

  /// Checking whether the input data corresponds to the expected result.
  Future<bool> verify(Uint8List payload, KDFResult expectedResult);

  /// Check if the password matches the expected result.
  Future<bool> verifyPassword(String password, KDFResult expectedResult);
}
