import 'package:foxid/foxid.dart';

import '../../service/database.dart';

/// Data accessor for the messages table.
abstract interface class MessageAccessor {
  /// Inserts the message into the database and returns it.
  Future<MessageTableData> insert(MessageTableCompanion companion);

  /// Returns an list of messages in the channel.
  Future<List<MessageTableData>> listByChannelId(
    FOxID channel, {
    FOxID? before,
    FOxID? after,
    int? limit,
  });

  /// Returns an list of messages in the channel.
  Future<List<MessageTableData>> listByCanonicalChannelId(
    String channel, {
    String? before,
    String? after,
    int? limit,
  });
}
