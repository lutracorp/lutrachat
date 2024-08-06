import 'package:injectable/injectable.dart';
import 'package:lutrachat_backend_database/lutrachat_backend_database.dart';
import 'package:shelf_plus/shelf_plus.dart';
import 'package:collection/collection.dart';

import '../../enumerable/error/channel.dart';
import '../../extension/request/context.dart';
import '../base/error.dart';
import '../base/middleware.dart';

/// Middleware for checking access to private channels.
@lazySingleton
final class RecipientMiddleware extends ServerMiddleware {
  /// Data accessor for the channel recipients table.
  final RecipientAccessor recipientAccessor;

  RecipientMiddleware(this.recipientAccessor);

  @override
  Handler call(Handler innerHandler) {
    return (Request request) async {
      final List<RecipientTableData> recipients =
          await recipientAccessor.findManyByChannelId(request.channel.id);

      final RecipientTableData? recipient = recipients
          .firstWhereOrNull((recipient) => recipient.user == request.user.id);

      if (recipient != null) {
        return innerHandler(
          request.change(context: {
            ...request.context,
            RequestContext.recipientKey: recipient,
          }),
        );
      }

      throw ServerError(ChannelErrorCode.notFound);
    };
  }
}
