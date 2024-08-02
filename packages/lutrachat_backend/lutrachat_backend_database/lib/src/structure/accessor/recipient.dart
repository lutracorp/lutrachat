import 'package:foxid/foxid.dart';

import '../../service/database.dart';
import 'base/foxid.dart';

/// Data accessor for the channel recipients table.
abstract interface class RecipientAccessor
    extends BaseFOxIDAccessor<RecipientTableData> {
  RecipientAccessor(super.attachedDatabase);
  /// Returns an list of recipients of the user.
  Future<List<RecipientTableData>> findManyByUserId(FOxID user);

  /// Returns an list of recipients of the user.
  Future<List<RecipientTableData>> findManyByCanonicalUserId(String user);

  /// Returns an list of recipients in the channel.
  Future<List<RecipientTableData>> findManyByChannelId(FOxID channel);

  /// Returns an list of recipients in the channel.
  Future<List<RecipientTableData>> findManyByCanonicalChannelId(String channel);
}
