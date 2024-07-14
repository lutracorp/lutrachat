import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../../service/database.dart';
import '../../table/channel.dart';
import '../base/channel.dart';
import '../channel.dart';

part 'channel.g.dart';

/// Data accessor for the channels table.
@LazySingleton(as: ChannelAccessor)
@DriftAccessor(tables: [ChannelTable])
final class ChannelAccessorImplementation extends ChannelAccessorBase
    with _$ChannelAccessorImplementationMixin
    implements ChannelAccessor {
  ChannelAccessorImplementation(super.attachedDatabase);

  /// Inserts the message into the database and returns it.
  @override
  Future<ChannelTableData> insert(ChannelTableCompanion companion) async {
    return await into(channelTable).insertReturning(companion);
  }

  @override
  Future<ChannelTableData?> findByCanonicalId(String id) async {
    final query = select(channelTable)
      ..where(
        (entity) => entity.id.equals(id),
      );

    return await query.getSingleOrNull();
  }
}
