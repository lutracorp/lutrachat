import 'package:drift/drift.dart';

import '../../enumerable/type/message.dart';
import '../converter/bitfield.dart';
import '../converter/foxid.dart';
import 'base/foxid.dart';
import 'channel.dart';
import 'user.dart';

/// A table containing channel messages data.
abstract class MessageTable extends BaseFOxIDTable {
  /// The channel the message was sent in.
  TextColumn get channel =>
      text().references(ChannelTable, #id).map(FOxIDConverter.instance)();

  /// The author of the message.
  TextColumn get author =>
      text().references(UserTable, #id).map(FOxIDConverter.instance)();

  /// The contents of the message.
  TextColumn get content => text().withLength(min: 1, max: 2000)();

  /// The type of the message.
  IntColumn get type =>
      intEnum<MessageType>().clientDefault(() => MessageType.standard.index)();

  /// The flags of the message.
  Int64Column get flags => int64()
      .map(BitFieldConverter.instance)
      .clientDefault(() => BigInt.zero)();

  @override
  String get tableName => 'messages';
}
