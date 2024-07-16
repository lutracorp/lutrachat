import 'package:foxid/foxid.dart';

import '../../service/database.dart';
import 'base/foxid.dart';

/// Data accessor for the messages table.
abstract interface class MessageAccessor
    extends BaseFOxIDAccessor<MessageTableData> {
  MessageAccessor(super.attachedDatabase);

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
