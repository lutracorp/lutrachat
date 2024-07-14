import 'package:foxid/foxid.dart';

import '../../service/database.dart';

/// Data accessor for the channels table.
abstract interface class ChannelAccessor {
  /// Inserts the message into the database and returns it.
  Future<ChannelTableData> insert(ChannelTableCompanion companion);

  /// Find a channel by their ID.
  Future<ChannelTableData?> findById(FOxID id);

  /// Find a channel by their ID in canonical string format.
  Future<ChannelTableData?> findByCanonicalId(String id);
}
