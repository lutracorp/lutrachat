import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:cryptography/helpers.dart';
import 'package:injectable/injectable.dart';

import '../../../gen/proto/service/kdf/v1/result.pb.dart';
import '../../configuration/kdf.dart';
import '../kdf.dart';

@LazySingleton(as: KDFService)
final class KDFServiceImplementation implements KDFService {
  final KdfAlgorithm algorithm;

  KDFServiceImplementation(KDFConfiguration configuration)
      : algorithm = configuration.algorithm;

  /// Generated random salt.
  Uint8List get randomNonce => randomBytes(32);

  @override
  Future<KDFResult> derive(
    Uint8List payload, {
    KdfAlgorithm? algorithm,
    List<int>? nonce,
  }) async {
    algorithm ??= this.algorithm;
    nonce ??= randomNonce;

    final SecretKey derivedKey = await algorithm.deriveKey(
      secretKey: SecretKey(payload),
      nonce: nonce,
    );

    final SecretKeyData derivedKeyData = await derivedKey.extract();

    return KDFResult(key: derivedKeyData.bytes, nonce: nonce);
  }

  @override
  Future<KDFResult> derivePassword(String password) async {
    final Uint8List payload = utf8.encode(password);

    return await derive(payload);
  }

  @override
  Future<bool> verify(Uint8List payload, KDFResult expectedResult) async {
    final KDFResult newResult = await derive(
      payload,
      nonce: expectedResult.nonce,
    );

    return constantTimeBytesEquality.equals(newResult.key, expectedResult.key);
  }

  @override
  Future<bool> verifyPassword(String password, KDFResult expectedResult) async {
    final Uint8List payload = utf8.encode(password);

    return await verify(payload, expectedResult);
  }
}
