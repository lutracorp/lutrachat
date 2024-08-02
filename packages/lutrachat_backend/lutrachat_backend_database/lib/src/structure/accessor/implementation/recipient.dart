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
  Future<RecipientTableData?> findOneByCanonicalId(String id) {
    final query = select(table)
      ..where(
        (entity) => entity.id.equals(id),
      );

    return query.getSingleOrNull();
  }

  @override
  Future<List<RecipientTableData>> findManyByCanonicalIds(
    Iterable<String> ids,
  ) {
    final query = select(table)
      ..where(
        (entity) => entity.id.isIn(ids),
      );

    return query.get();
  }

  @override
  Future<List<RecipientTableData>> findManyByUserId(FOxID user) async =>
      await findManyByCanonicalUserId(
        user.toJson(),
      );

  @override
  Future<List<RecipientTableData>> findManyByCanonicalUserId(String user) {
    final query = select(table)
      ..where(
        (entity) => entity.user.equals(user),
      );

    return query.get();
  }

  @override
  Future<List<RecipientTableData>> findManyByChannelId(FOxID channel) =>
      findManyByCanonicalChannelId(
        channel.toJson(),
      );

  @override
  Future<List<RecipientTableData>> findManyByCanonicalChannelId(
    String channel,
  ) {
    final query = select(table)
      ..where(
        (entity) => entity.channel.equals(channel),
      );

    return query.get();
  }

  @override
  TableInfo<$RecipientTableTable, RecipientTableData> get table =>
      recipientTable;
}
