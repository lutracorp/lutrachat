import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:cryptography/helpers.dart';
import 'package:dart_date/dart_date.dart';
import 'package:injectable/injectable.dart';

import '../../../gen/proto/service/token/v1/token.pb.dart';
import '../token.dart';

@LazySingleton(as: TokenService)
final class TokenServiceImplementation implements TokenService {
  static final MacAlgorithm macAlgorithm = Hmac.blake2s();
  static final Codec<List<int>, String> codec = Base64Codec.urlSafe();

  Future<TokenData> signData(
    List<int> payload,
    Uint8List secretKey, [
    DateTime? timestamp,
  ]) async {
    timestamp ??= DateTime.now();

    final TokenData tokenData = TokenData(
      payload: payload,
      timestamp: timestamp.toUtc().secondsSinceEpoch,
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
    final TokenData initialToken = TokenData.fromBuffer(
      codec.decode(token),
    );

    final TokenData resignedToken = await signData(
      initialToken.payload,
      secretKey,
      DateTime.fromMillisecondsSinceEpoch(
        initialToken.timestamp * Duration.millisecondsPerSecond,
        isUtc: true,
      ),
    );

    return constantTimeBytesEquality.equals(
      resignedToken.signature,
      initialToken.signature,
    );
  }
}
