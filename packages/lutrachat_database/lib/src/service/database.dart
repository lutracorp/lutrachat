import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../configuration/database.dart';

part 'database.g.dart';

/// Service for working with the database.
@lazySingleton
@DriftDatabase()
final class DatabaseService extends _$DatabaseService {
  DatabaseService(DatabaseConfiguration configuration)
      : super(configuration.queryExecutor);

  @override
  int get schemaVersion => 1;
}
