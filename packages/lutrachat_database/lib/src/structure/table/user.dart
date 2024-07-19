import 'package:drift/drift.dart';

import '../converter/bitfield.dart';
import 'base/foxid.dart';

/// A table containing user data.
abstract class UserTable extends BaseFOxIDTable {
  /// The user's name.
  TextColumn get name => text().withLength(min: 2, max: 32).unique()();

  /// The user's email address.
  TextColumn get email => text().withLength(min: 4, max: 256).unique()();

  /// The flags on a user.
  Int64Column get flags => int64()
      .map(BitFieldConverter.instance)
      .clientDefault(() => BigInt.zero)();

  /// A hash of the user's password.
  BlobColumn get passwordHash => blob()();

  @override
  String get tableName => 'users';
}
