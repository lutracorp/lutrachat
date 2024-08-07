import 'package:injectable/injectable.dart';
import 'package:lutrachat_backend_server/lutrachat_backend_server.dart';
import 'package:shelf_plus/shelf_plus.dart';

import '../../model/http/channel/create/request.dart';
import '../../model/http/message/create/request.dart';
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

  final ValidatorMiddleware validatorMiddleware;

  /// Middleware checking for channel existence.
  final ChannelMiddleware channelMiddleware;

  /// Middleware for checking access to private channels.
  final RecipientMiddleware recipientMiddleware;

  /// A controller that performs channel actions.
  final ChannelController channelController;

  /// A controller that performs message actions.
  final MessageController messageController;

  /// A controller that performs channel recipient actions.
  final RecipientController recipientController;

  ChannelRoute(
    this.authorizationMiddleware,
    this.channelMiddleware,
    this.validatorMiddleware,
    this.channelController,
    this.recipientMiddleware,
    this.messageController,
    this.recipientController,
  );

  @override
  Handler configure() => RouterPlus()
    ..get(
      '/',
      channelController.list,
      use: authorizationMiddleware.call,
    )
    ..post(
      '/',
      channelController.create,
      use: validatorMiddleware.body(ChannelCreateRequest.validate) +
          authorizationMiddleware.call,
    )
    ..get(
      '/<channel>',
      channelController.fetch,
      use: authorizationMiddleware.call +
          channelMiddleware.call +
          recipientMiddleware.call,
    )
    ..get(
      '/<channel>/messages',
      messageController.list,
      use: authorizationMiddleware.call +
          channelMiddleware.call +
          recipientMiddleware.call,
    )
    ..post(
      '/<channel>/messages',
      messageController.create,
      use: validatorMiddleware.body(MessageCreateRequest.validate) +
          authorizationMiddleware.call +
          channelMiddleware.call +
          recipientMiddleware.call,
    )
    ..get(
      '/<channel>/messages/<message>',
      messageController.fetch,
      use: authorizationMiddleware.call +
          channelMiddleware.call +
          recipientMiddleware.call,
    )
    ..get(
      '/<channel>/recipients',
      recipientController.list,
      use: authorizationMiddleware.call +
          channelMiddleware.call +
          recipientMiddleware.call,
    );
}
