import 'package:foxid/foxid.dart';
import 'package:injectable/injectable.dart';
import 'package:lutrachat_database/lutrachat_database.dart';
import 'package:shelf_plus/shelf_plus.dart';

import '../../../model/http/message/common/response.dart';
import '../../../model/http/message/create/request.dart';
import '../../../model/http/message/list/query.dart';
import '../message.dart';

@LazySingleton(as: MessageController)
final class MessageControllerImplementation implements MessageController {
  final DatabaseService databaseService;
  final MessageAccessor messageAccessor;

  MessageControllerImplementation(this.databaseService, this.messageAccessor);

  @override
  Future<MessageResponse> create(Request request, String target) async {
    final MessageCreateRequest messageCreatePayload =
        await request.body.as(MessageCreateRequest.fromJson);

    final UserTableData user =
        request.context['lutrachat/user'] as UserTableData;

    final MessageTableData message = await messageAccessor.insert(
      MessageTableCompanion.insert(
        channel: FOxID.fromJson(target),
        author: user.id,
        content: messageCreatePayload.content,
        type: MessageType.standard,
      ),
    );

    return MessageResponse.fromTableData(message);
  }

  @override
  Future<Iterable<MessageResponse>> list(Request request, String target) async {
    final MessageListQuery messageListQuery =
        MessageListQuery.fromJson(request.requestedUri.queryParameters);

    final List<MessageTableData> messages =
        await messageAccessor.listByCanonicalChannelId(target,
            after: messageListQuery.after,
            before: messageListQuery.before,
            limit: messageListQuery.limit);

    return messages.map(MessageResponse.fromTableData);
  }
}
