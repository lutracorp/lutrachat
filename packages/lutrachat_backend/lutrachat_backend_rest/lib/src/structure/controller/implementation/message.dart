import 'package:foxid/foxid.dart';
import 'package:injectable/injectable.dart';
import 'package:lutrachat_backend_database/lutrachat_backend_database.dart';
import 'package:lutrachat_backend_server/lutrachat_backend_server.dart';
import 'package:shelf_plus/shelf_plus.dart';

import '../../../model/http/common/message/response.dart';
import '../../../model/http/message/create/request.dart';
import '../../../model/http/message/list/query.dart';
import '../message.dart';

@LazySingleton(as: MessageController)
final class MessageControllerImplementation implements MessageController {
  /// Data accessor for the messages table.
  final MessageAccessor messageAccessor;

  /// Data accessor for the channels table.
  final ChannelAccessor channelAccessor;

  MessageControllerImplementation(
    this.messageAccessor,
    this.channelAccessor,
  );

  @override
  Future<MessageResponse> create(Request request, String _) async {
    final MessageCreateRequest messageCreatePayload =
        await request.body.as(MessageCreateRequest.fromJson);

    final MessageTableData message = await messageAccessor.insertOne(
      MessageTableCompanion.insert(
        channel: request.channel.id,
        author: request.user.id,
        content: messageCreatePayload.content,
      ),
    );

    return MessageResponse.fromTableData(message);
  }

  @override
  Future<Iterable<MessageResponse>> list(Request request, String _) async {
    final Map<String, String> query = request.requestedUri.queryParameters;

    final MessageListQuery messageListQuery = MessageListQuery.fromJson({
      ...query,
      'limit': num.tryParse(query['limit'] ?? ''),
    });

    final List<MessageTableData> messages =
        await messageAccessor.findManyByChannelId(request.channel.id,
            after: messageListQuery.after,
            before: messageListQuery.before,
            limit: messageListQuery.limit);

    return messages.map(MessageResponse.fromTableData);
  }

  @override
  Future<MessageResponse> fetch(
    Request request,
    String _,
    String messageId,
  ) async {
    final MessageTableData? messageData =
        await messageAccessor.findOneByCanonicalId(messageId);

    if (messageData != null && request.channel.id == messageData.channel) {
      return MessageResponse.fromTableData(messageData);
    }

    throw ServerError(MessageErrorCode.notFound);
  }
}
