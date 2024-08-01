import 'package:drift/drift.dart';

import '../../../service/database.dart';

abstract class BaseAccessor<DC extends DataClass>
    extends DatabaseAccessor<DatabaseService> {
  BaseAccessor(super.attachedDatabase);

  TableInfo<Table, DC> get table;

  Future<DC> insertOne(UpdateCompanion<DC> companion) {
    return into(table).insertReturning(companion);
  }

  Future<DC?> insertOneOrIgnore(UpdateCompanion<DC> companion) {
    return into(table).insertReturningOrNull(
      companion,
      mode: InsertMode.insertOrIgnore,
    );
  }
}
