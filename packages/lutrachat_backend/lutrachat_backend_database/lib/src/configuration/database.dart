import 'dart:io';

import 'package:drift/backends.dart';
import 'package:drift/native.dart';
import 'package:drift_postgres/drift_postgres.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lutrachat_backend_common/lutrachat_backend_common.dart';
import 'package:postgres/postgres.dart';

part 'database.freezed.dart';
part 'database.g.dart';

/// Database-related configuration.
@freezed
sealed class DatabaseConfiguration with _$DatabaseConfiguration {
  const DatabaseConfiguration._();

  /// In-memory database backend.
  const factory DatabaseConfiguration.memory() = _DatabaseConfigurationMemory;

  /// Sqlite database backend.
  const factory DatabaseConfiguration.sqlite({
    /// Database file.
    @FileConverter.instance required File file,
  }) = _DatabaseConfigurationSqlite;

  /// PostgreSQL database backend.
  const factory DatabaseConfiguration.postgres({
    @Default(SslMode.disable) SslMode sslMode,
    @Default('lutrachat') String database,
    @Default('localhost') String host,
    @Default(5432) int port,
    String? username,
    String? password,
  }) = _DatabaseConfigurationPostgres;

  /// A query executor for use with the database connector.
  QueryExecutor get queryExecutor => switch (this) {
        _DatabaseConfigurationMemory() => NativeDatabase.memory(),
        _DatabaseConfigurationSqlite(:final File file) => NativeDatabase(file),
        _DatabaseConfigurationPostgres(
          :final SslMode sslMode,
          :final String database,
          :final String host,
          :final int port,
          :final String? username,
          :final String? password,
        ) =>
          PgDatabase(
            endpoint: Endpoint(
              host: host,
              port: port,
              database: database,
              username: username,
              password: password,
            ),
            settings: ConnectionSettings(
              sslMode: sslMode,
              applicationName: 'LutraChat',
            ),
          ),
      };

  factory DatabaseConfiguration.fromJson(Map<String, dynamic> json) =>
      _$DatabaseConfigurationFromJson(json);
}
