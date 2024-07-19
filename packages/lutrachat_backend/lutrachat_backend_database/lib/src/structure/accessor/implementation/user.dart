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
  Future<UserTableData?> findByCanonicalId(String id) async {
    final query = select(table)
      ..where(
        (entity) => entity.id.equals(id),
      );

    return await query.getSingleOrNull();
  }

  @override
  Future<UserTableData?> findByName(String username) async {
    final query = select(table)
      ..where(
        (entity) => entity.name.equals(username),
      );

    return await query.getSingleOrNull();
  }

  @override
  Future<UserTableData?> findByEmail(String email) async {
    final query = select(table)
      ..where(
        (entity) => entity.email.equals(email),
      );

    return await query.getSingleOrNull();
  }

  @override
  TableInfo<$UserTableTable, UserTableData> get table => userTable;
}
