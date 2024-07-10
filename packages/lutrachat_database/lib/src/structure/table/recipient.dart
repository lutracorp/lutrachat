import 'package:drift/drift.dart';

import '../converter/foxid.dart';
import 'base/foxid.dart';
import 'channel.dart';
import 'user.dart';

/// A table containing private channel recipients data.
abstract class RecipientTable extends BaseFOxIDTable {
  /// The channel to which the recipient has been added.
  TextColumn get channel =>
      text().references(ChannelTable, #id).map(FOxIDConverter.instance)();

  /// The recipient that added to the channel.
  TextColumn get user =>
      text().references(UserTable, #id).map(FOxIDConverter.instance)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {channel, user}
      ];

  @override
  String get tableName => 'recipients';
}
