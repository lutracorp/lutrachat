import 'package:dartfield/dartfield.dart';
import 'package:drift/drift.dart';
import 'package:foxid/foxid.dart';
import 'package:injectable/injectable.dart';

import '../configuration/database.dart';
import '../structure/converter/bitfield.dart';
import '../structure/converter/foxid.dart';
import '../structure/table/profile.dart';
import '../structure/table/user.dart';

part 'database.g.dart';

/// Service for working with the database.
@lazySingleton
@DriftDatabase(tables: [UserTable, ProfileTable])
final class DatabaseService extends _$DatabaseService {
  DatabaseService(DatabaseConfiguration configuration)
      : super(configuration.queryExecutor);

  @override
  int get schemaVersion => 1;
}
