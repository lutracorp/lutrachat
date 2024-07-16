import 'package:foxid/foxid.dart';

import '../../service/database.dart';
import 'base/foxid.dart';

/// Data accessor for the channel recipients table.
abstract interface class RecipientAccessor
    extends BaseFOxIDAccessor<RecipientTableData> {
  RecipientAccessor(super.attachedDatabase);

  /// Returns an list of recipients in the channel.
  Future<List<RecipientTableData>> listByChannelId(FOxID channel);

  /// Returns an list of messages in the channel.
  Future<List<RecipientTableData>> listByCanonicalChannelId(String channel);
}
