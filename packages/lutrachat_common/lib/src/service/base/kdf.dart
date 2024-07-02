import 'dart:convert';
import 'dart:typed_data';

import '../../../gen/proto/service/kdf/v1/result.pb.dart';
import '../kdf.dart';

/// The base of service that provides the KDF.
abstract base class KDFServiceBase implements KDFService {
  @override
  Future<Uint8List> deriveBytes(Uint8List payload) async {
    final KDFResult result = await derive(payload);

    return result.writeToBuffer();
  }

  @override
  Future<KDFResult> derivePassword(String password) async {
    final Uint8List payload = utf8.encode(password);

    return await derive(payload);
  }

  @override
  Future<Uint8List> derivePasswordBytes(String password) async {
    final Uint8List payload = utf8.encode(password);

    return await deriveBytes(payload);
  }

  @override
  Future<bool> verifyBytes(Uint8List payload, Uint8List expected) async {
    final KDFResult expectedResult = KDFResult.fromBuffer(expected);

    return await verify(payload, expectedResult);
  }

  @override
  Future<bool> verifyPassword(String password, KDFResult expected) async {
    final Uint8List payload = utf8.encode(password);

    return await verify(payload, expected);
  }

  @override
  Future<bool> verifyPasswordBytes(String password, Uint8List expected) async {
    final Uint8List payload = utf8.encode(password);

    return await verifyBytes(payload, expected);
  }
}
