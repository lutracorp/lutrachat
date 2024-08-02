import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../../service/database.dart';
import '../../table/user.dart';
import '../base/foxid.dart';
import '../user.dart';

part 'user.g.dart';

@LazySingleton(as: UserAccessor)
@DriftAccessor(tables: [UserTable])
final class UserAccessorImplementation extends BaseFOxIDAccessor<UserTableData>
    with _$UserAccessorImplementationMixin
    implements UserAccessor {
  UserAccessorImplementation(super.attachedDatabase);

  @override
  Future<UserTableData?> findOneByCanonicalId(String id) {
    final query = select(table)
      ..where(
        (entity) => entity.id.equals(id),
      );

    return query.getSingleOrNull();
  }

  @override
  Future<List<UserTableData>> findManyByCanonicalIds(
    Iterable<String> ids,
  ) {
    final query = select(table)
      ..where(
        (entity) => entity.id.isIn(ids),
      );

    return query.get();
  }

  @override
  Future<UserTableData?> findOneByName(String username) {
    final query = select(table)
      ..where(
        (entity) => entity.name.equals(username),
      );

    return query.getSingleOrNull();
  }

  @override
  Future<UserTableData?> findOneByEmail(String email) {
    final query = select(table)
      ..where(
        (entity) => entity.email.equals(email),
      );

    return query.getSingleOrNull();
  }

  @override
  TableInfo<$UserTableTable, UserTableData> get table => userTable;
}
