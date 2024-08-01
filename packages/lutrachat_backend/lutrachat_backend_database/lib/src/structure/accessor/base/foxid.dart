import 'package:drift/drift.dart';
import 'package:foxid/foxid.dart';

import '../../converter/foxid.dart';
import 'base.dart';

abstract class BaseFOxIDAccessor<DC extends DataClass>
    extends BaseAccessor<DC> {
  BaseFOxIDAccessor(super.attachedDatabase);

  /// Find only one [DC] by ID in canonical format.
  Future<DC?> findOneByCanonicalId(String id);

  /// Find only one [DC] by ID.
  Future<DC?> findOneById(FOxID id) {
    final String canonicalId = FOxIDConverter.instance.toSql(id);

    return findOneByCanonicalId(canonicalId);
  }

  /// Find many [DC] by list of ID's in canonical format.
  Future<Iterable<DC>> findManyByCanonicalIds(Iterable<String> ids);

  /// Find many [DC] by list of ID's.
  Future<Iterable<DC>> findManyByIds(Iterable<FOxID> ids) {
    final Iterable<String> canonicalIds =
        ids.map(FOxIDConverter.instance.toSql);

    return findManyByCanonicalIds(canonicalIds);
  }

  /// Checks if [DC] exists by ID in canonical format.
  Future<bool> existsByCanonicalId(String id) async {
    return await findOneByCanonicalId(id) != null;
  }

  /// Checks if [DC] exists by ID.
  Future<bool> existsById(FOxID id) {
    final String canonicalId = FOxIDConverter.instance.toSql(id);

    return existsByCanonicalId(canonicalId);
  }
}
