import 'package:foxid/foxid.dart';

import '../../service/database.dart';

/// Data accessor for the users table.
abstract interface class UserAccessor {
  /// Inserts the user into the database and returns it if it did not exist previously.
  Future<UserTableData?> insertOrIgnore(UserTableCompanion companion);

  /// Find a user by their ID.
  Future<UserTableData?> findById(FOxID id);

  /// Find a user by their ID in canonical string format.
  Future<UserTableData?> findByCanonicalId(String id);

  /// Find a user by their name.
  Future<UserTableData?> findByName(String username);

  /// Find a user by their email address.
  Future<UserTableData?> findByEmail(String email);
}
