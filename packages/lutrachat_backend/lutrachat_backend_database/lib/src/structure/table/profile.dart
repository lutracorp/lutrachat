import 'package:drift/drift.dart';

import '../converter/foxid.dart';
import 'base/foxid.dart';
import 'user.dart';

/// A table containing user profile data.
abstract class ProfileTable extends BaseFOxIDTable {
  /// The user to which this profile belongs.
  TextColumn get user =>
      text().references(UserTable, #id).map(FOxIDConverter.instance)();

  /// The user name displayed in the profile.
  TextColumn get name => text().withLength(min: 2, max: 32).nullable()();

  @override
  String get tableName => 'profiles';
}
