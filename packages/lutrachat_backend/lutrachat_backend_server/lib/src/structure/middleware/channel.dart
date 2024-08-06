import 'package:injectable/injectable.dart';
import 'package:lutrachat_backend_database/lutrachat_backend_database.dart';
import 'package:shelf_plus/shelf_plus.dart';

import '../../enumerable/error/channel.dart';
import '../../extension/request/context.dart';
import '../base/error.dart';
import '../base/middleware.dart';

/// Middleware checking for channel existence.
@lazySingleton
final class ChannelMiddleware extends ServerMiddleware {
  /// Data accessor for the user table.
  final ChannelAccessor channelAccessor;

  ChannelMiddleware(this.channelAccessor);

  Handler process(Handler innerHandler, String channelParam) {
    return (Request request) async {
      final String id = request.params[channelParam]!;

      final ChannelTableData? data =
          await channelAccessor.findOneByCanonicalId(id);

      if (data != null) {
        return await innerHandler(
          request.change(context: {
            ...request.context,
            RequestContext.channelKey: data,
          }),
        );
      }

      throw ServerError(ChannelErrorCode.notFound);
    };
  }

  @override
  Handler call(Handler innerHandler) => process(innerHandler, 'channel');
}
