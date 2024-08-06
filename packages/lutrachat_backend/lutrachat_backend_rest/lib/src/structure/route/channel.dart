import 'package:injectable/injectable.dart';
import 'package:lutrachat_backend_server/lutrachat_backend_server.dart';
import 'package:shelf_plus/shelf_plus.dart';

import '../controller/channel.dart';
import '../controller/message.dart';
import '../controller/recipient.dart';

/// A route that handles channel actions.
@LazySingleton(as: ServerRoute)
final class ChannelRoute extends ServerRoute {
  @override
  final String prefix = '/channels';

  /// Middleware to verify authorization token.
  final AuthorizationMiddleware authorizationMiddleware;

  /// Middleware checking for channel existence.
  final ChannelMiddleware channelMiddleware;

  /// A controller that performs channel actions.
  final ChannelController channelController;

  /// A controller that performs message actions.
  final MessageController messageController;

  /// A controller that performs channel recipient actions.
  final RecipientController recipientController;

  ChannelRoute(
    this.authorizationMiddleware,
    this.channelMiddleware,
    this.channelController,
    this.messageController,
    this.recipientController,
  );

  @override
  Handler configure() => RouterPlus()
    ..get(
      '/',
      channelController.list,
      use: authorizationMiddleware,
    )
    ..post(
      '/',
      channelController.create,
      use: authorizationMiddleware,
    )
    ..get(
      '/<channel>',
      channelController.fetch,
      use: authorizationMiddleware.call + channelMiddleware.call,
    )
    ..get(
      '/<channel>/messages',
      messageController.list,
      use: authorizationMiddleware.call + channelMiddleware.call,
    )
    ..post(
      '/<channel>/messages',
      messageController.create,
      use: authorizationMiddleware.call + channelMiddleware.call,
    )
    ..get(
      '/<channel>/messages/<message>',
      messageController.fetch,
      use: authorizationMiddleware.call + channelMiddleware.call,
    )
    ..get(
      '/<channel>/recipients',
      recipientController.list,
      use: authorizationMiddleware.call + channelMiddleware.call,
    );
}
