import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../../service/database.dart';
import '../../table/channel.dart';
import '../base/foxid.dart';
import '../channel.dart';

part 'channel.g.dart';

@LazySingleton(as: ChannelAccessor)
@DriftAccessor(tables: [ChannelTable])
final class ChannelAccessorImplementation
    extends BaseFOxIDAccessor<ChannelTableData>
    with _$ChannelAccessorImplementationMixin
    implements ChannelAccessor {
  ChannelAccessorImplementation(super.attachedDatabase);

  @override
  Future<ChannelTableData?> findOneByCanonicalId(String id) {
    final query = select(table)
      ..where(
        (entity) => entity.id.equals(id),
      );

    return query.getSingleOrNull();
  }

  @override
  Future<Iterable<ChannelTableData>> findManyByCanonicalIds(
    Iterable<String> ids,
  ) {
    final query = select(table)
      ..where(
        (entity) => entity.id.isIn(ids),
      );

    return query.get();
  }

  @override
  TableInfo<$ChannelTableTable, ChannelTableData> get table => channelTable;
}
