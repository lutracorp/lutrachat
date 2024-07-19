import 'package:drift/drift.dart';
import 'package:foxid/foxid.dart';
import 'package:injectable/injectable.dart';

import '../../../service/database.dart';
import '../../table/recipient.dart';
import '../base/foxid.dart';
import '../recipient.dart';

part 'recipient.g.dart';

@LazySingleton(as: RecipientAccessor)
@DriftAccessor(tables: [RecipientTable])
final class RecipientAccessorImplementation
    extends BaseFOxIDAccessor<RecipientTableData>
    with _$RecipientAccessorImplementationMixin
    implements RecipientAccessor {
  RecipientAccessorImplementation(super.attachedDatabase);

  @override
  Future<RecipientTableData?> findByCanonicalId(String id) async {
    final query = select(table)
      ..where(
        (entity) => entity.id.equals(id),
      );

    return await query.getSingleOrNull();
  }

  @override
  Future<List<RecipientTableData>> listByChannelId(
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

  @override
  Future<List<RecipientTableData>> listByCanonicalChannelId(
    String channel, {
    String? before,
    String? after,
    int? limit,
  }) async {
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

    return await query.get();
  }

  @override
  TableInfo<$RecipientTableTable, RecipientTableData> get table => recipientTable;
}
