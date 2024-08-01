import 'package:drift/drift.dart';
import 'package:foxid/foxid.dart';
import 'package:injectable/injectable.dart';

import '../../../service/database.dart';
import '../../table/message.dart';
import '../message.dart';
import '../base/foxid.dart';

part 'message.g.dart';

@LazySingleton(as: MessageAccessor)
@DriftAccessor(tables: [MessageTable])
final class MessageAccessorImplementation
    extends BaseFOxIDAccessor<MessageTableData>
    with _$MessageAccessorImplementationMixin
    implements MessageAccessor {
  MessageAccessorImplementation(super.attachedDatabase);

  @override
  Future<MessageTableData?> findOneByCanonicalId(String id) {
    final query = select(table)
      ..where(
        (entity) => entity.id.equals(id),
      );

    return query.getSingleOrNull();
  }

  @override
  Future<Iterable<MessageTableData>> findManyByCanonicalIds(
    Iterable<String> ids,
  ) {
    final query = select(table)
      ..where(
        (entity) => entity.id.isIn(ids),
      );

    return query.get();
  }

  @override
  Future<List<MessageTableData>> findManyByChannelId(
    FOxID channel, {
    FOxID? before,
    FOxID? after,
    int? limit,
  }) =>
      findManyByCanonicalChannelId(
        channel.toJson(),
        before: before?.toJson(),
        after: after?.toJson(),
        limit: limit,
      );

  @override
  Future<List<MessageTableData>> findManyByCanonicalChannelId(
    String channel, {
    String? before,
    String? after,
    int? limit,
  }) {
    final query = select(table)
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

    return query.get();
  }

  @override
  TableInfo<$MessageTableTable, MessageTableData> get table => messageTable;
}
