import '../../service/database.dart';
import 'base/foxid.dart';

/// Data accessor for the channels table.
abstract interface class ChannelAccessor
    extends BaseFOxIDAccessor<ChannelTableData> {
  ChannelAccessor(super.attachedDatabase);
}
