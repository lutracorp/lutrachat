import 'package:drift/drift.dart';

import '../../converter/foxid.dart';

/// Base table where records are identified by FOxID.
abstract class BaseFOxIDTable extends Table {
  /// The identifier of the record in the database.
  TextColumn get id => text()
      .map(FOxIDConverter.instance)
      .clientDefault(FOxIDConverter.generate)();

  @override
  Set<Column> get primaryKey => {id};
}
