import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:cryptography/helpers.dart';
import 'package:injectable/injectable.dart';

import '../../../gen/proto/google/protobuf/timestamp.pb.dart';
import '../../../gen/proto/lutracorp/lutrachat/common/service/token/v1/data.pb.dart';
import '../../configuration/token.dart';
import '../token.dart';

@LazySingleton(as: TokenService)
final class TokenServiceImplementation implements TokenService {
  /// Mac algorithm used to sign tokens.
  static final MacAlgorithm macAlgorithm = Poly1305();

  /// Codec used to encode tokens.
  final Codec<List<int>, String> codec;

  TokenServiceImplementation(TokenConfiguration configuration)
      : codec = configuration.codec.instance;

  @override
  TokenData decode(String token) {
    return TokenData.fromBuffer(
      codec.decode(token),
    );
  }

  Future<TokenData> signData(
    List<int> payload,
    Uint8List secretKey, [
    DateTime? timestamp,
  ]) async {
    timestamp ??= DateTime.now();

    final TokenData tokenData = TokenData(
      payload: payload,
      timestamp: Timestamp.fromDateTime(timestamp),
    );

    final Mac calculatedMac = await macAlgorithm.calculateMac(
      tokenData.writeToBuffer(),
      secretKey: SecretKey(secretKey),
    );

    return tokenData..signature = calculatedMac.bytes;
  }

  @override
  Future<String> sign(
    Uint8List payload,
    Uint8List secretKey, [
    DateTime? timestamp,
  ]) async {
    final TokenData tokenData = await signData(payload, secretKey, timestamp);

    return codec.encode(
      tokenData.writeToBuffer(),
    );
  }

  @override
  Future<bool> verify(String token, Uint8List secretKey) async {
    final TokenData initialToken = decode(token);

    final TokenData resignedToken = await signData(
      initialToken.payload,
      secretKey,
      initialToken.timestamp.toDateTime(),
    );

    return constantTimeBytesEquality.equals(
      resignedToken.signature,
      initialToken.signature,
    );
  }
}
