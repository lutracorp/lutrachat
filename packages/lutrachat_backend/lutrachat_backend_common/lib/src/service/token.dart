import 'dart:typed_data';

import '../../gen/proto/lutracorp/lutrachat/common/service/token/v1/data.pb.dart';

/// A service for signing and verifying tokens.
abstract interface class TokenService {
  /// Decodes the token into data.
  TokenData decode(String token);

  /// Signs the token with a secret key.
  Future<String> sign(
    Uint8List payload,
    Uint8List secretKey, [
    DateTime? timestamp,
  ]);

  /// Checks the validity of the token.
  Future<bool> verify(String token, Uint8List secretKey);
}
