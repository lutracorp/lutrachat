import 'package:drift/drift.dart';

import '../../enumerable/type/channel.dart';
import '../converter/bitfield.dart';
import 'base/foxid.dart';

/// A table containing channel data.
abstract class ChannelTable extends BaseFOxIDTable {
  /// The type of the channel.
  IntColumn get type => intEnum<ChannelType>()();

  /// The name of the channel.
  TextColumn get name => text().withLength(min: 1, max: 32)();

  /// The flags of the channel.
  Int64Column get flags => int64().map(BitFieldConverter.instance)();

  @override
  String get tableName => 'channels';
}
