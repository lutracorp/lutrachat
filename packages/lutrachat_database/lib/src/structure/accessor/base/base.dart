import 'package:drift/drift.dart';

import '../../../service/database.dart';

abstract class BaseAccessor<DC extends DataClass>
    extends DatabaseAccessor<DatabaseService> {
  BaseAccessor(super.attachedDatabase);

  TableInfo<Table, DC> get table;

  Future<DC> insert(
    UpdateCompanion<DC> companion,
  ) async {
    return await into(table).insertReturning(companion);
  }

  Future<DC?> insertOrIgnore(
    UpdateCompanion<DC> companion,
  ) async {
    return await into(table).insertReturningOrNull(
      companion,
      mode: InsertMode.insertOrIgnore,
    );
  }
}
