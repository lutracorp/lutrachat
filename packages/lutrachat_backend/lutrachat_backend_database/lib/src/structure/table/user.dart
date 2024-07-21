import 'package:drift/drift.dart';

import '../../enumerable/type/user.dart';
import '../converter/bitfield.dart';
import 'base/foxid.dart';

/// A table containing user data.
abstract class UserTable extends BaseFOxIDTable {
  /// The user's name.
  TextColumn get name => text().withLength(min: 2, max: 32).unique()();

  /// The user's email address.
  TextColumn get email => text().withLength(min: 4, max: 256).unique()();

  /// A hash of the user's password.
  BlobColumn get passwordHash => blob()();

  /// The type of the user.
  IntColumn get type =>
      intEnum<UserType>().clientDefault(() => UserType.user.index)();

  /// The flags on a user.
  Int64Column get flags => int64()
      .map(BitFieldConverter.instance)
      .clientDefault(() => BigInt.zero)();

  @override
  String get tableName => 'users';
}
