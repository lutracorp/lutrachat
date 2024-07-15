import 'package:injectable/injectable.dart';
import 'package:lutrachat_server/lutrachat_server.dart';
import 'package:shelf_plus/shelf_plus.dart';

import '../controller/channel.dart';
import '../controller/message.dart';

/// A route that handles channel actions.
@LazySingleton(as: ServerRoute)
final class ChannelRoute extends ServerRoute {
  @override
  final String prefix = '/channels';

  /// Middleware to verify authorization token.
  final AuthorizationMiddleware authorizationMiddleware;

  /// A controller that performs channel actions.
  final ChannelController channelController;

  /// A controller that performs message actions.
  final MessageController messageController;

  ChannelRoute(
    this.authorizationMiddleware,
    this.channelController,
    this.messageController,
  );

  @override
  Handler configure() => RouterPlus()
    ..get(
      '/<target>',
      channelController.fetch,
      use: authorizationMiddleware,
    )
    ..get(
      '/<target>/messages',
      messageController.list,
      use: authorizationMiddleware,
    )
    ..post(
      '/<target>/messages',
      messageController.create,
      use: authorizationMiddleware,
    );
}
