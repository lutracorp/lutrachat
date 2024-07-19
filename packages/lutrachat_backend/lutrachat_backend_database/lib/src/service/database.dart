import 'package:dartfield/dartfield.dart';
import 'package:drift/drift.dart';
import 'package:foxid/foxid.dart';
import 'package:injectable/injectable.dart';

import '../configuration/database.dart';
import '../enumerable/type/channel.dart';
import '../enumerable/type/message.dart';
import '../structure/converter/bitfield.dart';
import '../structure/converter/foxid.dart';
import '../structure/table/channel.dart';
import '../structure/table/message.dart';
import '../structure/table/profile.dart';
import '../structure/table/recipient.dart';
import '../structure/table/user.dart';

part 'database.g.dart';

/// Service for working with the database.
@lazySingleton
@DriftDatabase(tables: [
  ChannelTable,
  MessageTable,
  ProfileTable,
  RecipientTable,
  UserTable,
])
final class DatabaseService extends _$DatabaseService {
  /// Database-related configuration.
  final DatabaseConfiguration configuration;

  DatabaseService(this.configuration) : super(configuration.queryExecutor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          if (executor.dialect == SqlDialect.sqlite) {
            await customStatement('PRAGMA foreign_keys = ON');
          }
        },
      );
}
