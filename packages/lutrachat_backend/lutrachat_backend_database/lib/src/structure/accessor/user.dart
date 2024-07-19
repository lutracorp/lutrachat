import '../../service/database.dart';
import 'base/foxid.dart';

/// Data accessor for the users table.
abstract interface class UserAccessor extends BaseFOxIDAccessor<UserTableData> {
  UserAccessor(super.attachedDatabase);

  /// Find a user by their name.
  Future<UserTableData?> findByName(String username);

  /// Find a user by their email address.
  Future<UserTableData?> findByEmail(String email);
}
