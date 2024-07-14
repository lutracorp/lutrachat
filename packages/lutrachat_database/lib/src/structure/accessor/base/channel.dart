import 'package:drift/drift.dart';
import 'package:foxid/foxid.dart';

import '../../../service/database.dart';
import '../channel.dart';

///
abstract base class ChannelAccessorBase
    extends DatabaseAccessor<DatabaseService> implements ChannelAccessor {
  ChannelAccessorBase(super.attachedDatabase);

  @override
  Future<ChannelTableData?> findById(FOxID id) async => await findByCanonicalId(
        id.toJson(),
      );
}
