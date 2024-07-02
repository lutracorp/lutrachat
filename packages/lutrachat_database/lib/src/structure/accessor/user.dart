import 'package:drift/drift.dart';
import 'package:foxid/foxid.dart';
import 'package:injectable/injectable.dart';

import '../../service/database.dart';
import '../converter/foxid.dart';
import '../table/user.dart';

part 'user.g.dart';

/// Data accessor for the user table.
@lazySingleton
@DriftAccessor(tables: [UserTable])
final class UserAccessor extends DatabaseAccessor<DatabaseService>
    with _$UserAccessorMixin {
  UserAccessor(super.attachedDatabase);

  /// Inserts the user into the database and returns it if it did not exist previously.
  Future<UserTableData?> insertOrIgnore(UserTableCompanion companion) async {
    return await into(userTable).insertReturningOrNull(
      companion,
      mode: InsertMode.insertOrIgnore,
    );
  }

  /// Find a user by their ID.
  Future<UserTableData?> findById(FOxID id) async {
    final idSql = FOxIDConverter.instance.toSql(id);
    final query = select(userTable)..where((entity) => entity.id.equals(idSql));

    return await query.getSingleOrNull();
  }

  /// Find a user by their name.
  Future<UserTableData?> findByName(String username) async {
    final query = select(userTable)
      ..where((entity) => entity.name.equals(username));

    return await query.getSingleOrNull();
  }

  /// Find a user by their email address.
  Future<UserTableData?> findByEmail(String email) async {
    final query = select(userTable)
      ..where((entity) => entity.email.equals(email));

    return await query.getSingleOrNull();
  }
}
