import 'dart:typed_data';

/// A service for signing and verifying tokens.
abstract interface class TokenService {
  /// Signs the token with a secret key.
  Future<String> sign(
    Uint8List payload,
    Uint8List secretKey, [
    DateTime? timestamp,
  ]);

  /// Checks the validity of the token.
  Future<bool> verify(String token, Uint8List secretKey);
}
