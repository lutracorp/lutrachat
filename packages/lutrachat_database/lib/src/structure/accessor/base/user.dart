import 'package:drift/drift.dart';
import 'package:foxid/foxid.dart';

import '../../../service/database.dart';
import '../user.dart';

///
abstract base class UserAccessorBase extends DatabaseAccessor<DatabaseService>
    implements UserAccessor {
  UserAccessorBase(super.attachedDatabase);

  @override
  Future<UserTableData?> findById(FOxID id) async => await findByCanonicalId(
        id.toJson(),
      );
}
