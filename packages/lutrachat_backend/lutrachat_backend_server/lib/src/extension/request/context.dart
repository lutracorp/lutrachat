import 'package:lutrachat_backend_database/lutrachat_backend_database.dart';
import 'package:shelf_plus/shelf_plus.dart';

/// Extension on [Request] to easily manipulate with [Request.context].
extension RequestContext on Request {
  /// Prefix for context keys.
  static const keyPrefix = 'chat.lutracorp.su';

  /// Context key for authorized user.
  static const userKey = '$keyPrefix/user';

  /// Context key for requested channel.
  static const channelKey = '$keyPrefix/channel';

  /// Authorized user data.
  UserTableData get user => context[userKey] as UserTableData;

  /// Requested channel.
  ChannelTableData get channel => context[channelKey] as ChannelTableData;
}
