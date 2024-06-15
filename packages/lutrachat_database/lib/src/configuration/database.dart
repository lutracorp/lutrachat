import 'dart:io';

import 'package:drift/backends.dart';
import 'package:drift/native.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lutrachat_common/lutrachat_common.dart';

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

  /// A query executor for use with the database connector.
  QueryExecutor get queryExecutor => switch (this) {
        _DatabaseConfigurationMemory() => NativeDatabase.memory(),
        _DatabaseConfigurationSqlite(:final file) => NativeDatabase(file),
      };

  factory DatabaseConfiguration.fromJson(Map<String, dynamic> json) =>
      _$DatabaseConfigurationFromJson(json);
}
