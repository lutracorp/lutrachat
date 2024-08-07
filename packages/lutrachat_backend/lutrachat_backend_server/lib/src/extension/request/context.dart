import 'package:luthor/luthor.dart';
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

  /// Context key for recipient of the requested channel.
  static const recipientKey = '$keyPrefix/recipient';

  /// Context key of validated schema result.
  static const validationResultKey = '$keyPrefix/validationResult';

  /// Authorized user data.
  UserTableData get user => context[userKey] as UserTableData;

  /// Requested channel.
  ChannelTableData get channel => context[channelKey] as ChannelTableData;

  /// Authorized user recipient of requested channel.
  RecipientTableData get recipient =>
      context[recipientKey] as RecipientTableData;

  /// Validated schema result.
  SchemaValidationSuccess get validationResult =>
      context[validationResultKey] as SchemaValidationSuccess;
}
