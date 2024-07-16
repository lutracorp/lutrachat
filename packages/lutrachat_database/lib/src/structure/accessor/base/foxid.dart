import 'package:drift/drift.dart';
import 'package:foxid/foxid.dart';

import '../../converter/foxid.dart';
import 'base.dart';

abstract class BaseFOxIDAccessor<DC extends DataClass>
    extends BaseAccessor<DC> {
  BaseFOxIDAccessor(super.attachedDatabase);

  Future<DC?> findByCanonicalId(String id);

  Future<bool> existsByCanonicalId(String id) async {
    return await findByCanonicalId(id) != null;
  }

  Future<DC?> findById(FOxID id) async {
    final String canonicalId = FOxIDConverter.instance.toSql(id);

    return await findByCanonicalId(canonicalId);
  }

  Future<bool> existsById(FOxID id) async {
    final String canonicalId = FOxIDConverter.instance.toSql(id);

    return await existsByCanonicalId(canonicalId);
  }
}
