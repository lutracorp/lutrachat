import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../../service/database.dart';
import '../../table/message.dart';
import '../base/message.dart';
import '../message.dart';

part 'message.g.dart';

@LazySingleton(as: MessageAccessor)
@DriftAccessor(tables: [MessageTable])
final class MessageAccessorImplementation extends MessageAccessorBase
    with _$MessageAccessorImplementationMixin
    implements MessageAccessor {
  MessageAccessorImplementation(super.attachedDatabase);

  @override
  Future<MessageTableData> insert(MessageTableCompanion companion) async {
    return await into(messageTable).insertReturning(companion);
  }

  @override
  Future<List<MessageTableData>> listByCanonicalChannelId(
    String channel, {
    String? before,
    String? after,
    int? limit,
  }) async {
    final query = select(messageTable)
      ..limit(limit ?? 50)
      ..where(
        (entity) => entity.channel.equals(channel),
      )
      ..orderBy([
        (entity) => OrderingTerm.desc(entity.id),
      ]);

    if (before != null) {
      query.where(
        (entity) => entity.id.isSmallerThanValue(before),
      );
    }

    if (after != null) {
      query.where(
        (entity) => entity.id.isBiggerThanValue(after),
      );
    }

    return await query.get();
  }
}
