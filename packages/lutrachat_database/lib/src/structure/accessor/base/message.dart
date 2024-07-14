import 'package:drift/drift.dart';
import 'package:foxid/foxid.dart';

import '../../../service/database.dart';
import '../message.dart';

///
abstract base class MessageAccessorBase
    extends DatabaseAccessor<DatabaseService> implements MessageAccessor {
  MessageAccessorBase(super.attachedDatabase);

  @override
  Future<List<MessageTableData>> listByChannelId(
    FOxID channel, {
    FOxID? before,
    FOxID? after,
    int? limit,
  }) async =>
      await listByCanonicalChannelId(
        channel.toJson(),
        before: before?.toJson(),
        after: after?.toJson(),
        limit: limit,
      );
}
