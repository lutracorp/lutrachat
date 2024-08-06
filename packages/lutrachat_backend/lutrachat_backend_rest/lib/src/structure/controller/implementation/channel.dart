import 'package:foxid/foxid.dart';
import 'package:injectable/injectable.dart';
import 'package:lutrachat_backend_database/lutrachat_backend_database.dart';
import 'package:lutrachat_backend_server/lutrachat_backend_server.dart';
import 'package:shelf_plus/shelf_plus.dart';

import '../../../model/http/channel/create/request.dart';
import '../../../model/http/common/channel/response.dart';
import '../channel.dart';

@LazySingleton(as: ChannelController)
final class ChannelControllerImplementation implements ChannelController {
  /// Data accessor for the channels table.
  final ChannelAccessor channelAccessor;

  /// Data accessor for the channel recipients table.
  final RecipientAccessor recipientAccessor;

  ChannelControllerImplementation(
    this.channelAccessor,
    this.recipientAccessor,
  );

  @override
  Future<ChannelResponse> fetch(Request request, String channelId) async {
    return ChannelResponse.fromTableData(request.channel);
  }

  @override
  Future<Iterable<ChannelResponse>> list(Request request) async {
    final List<RecipientTableData> recipients =
        await recipientAccessor.findManyByUserId(request.user.id);

    final Iterable<FOxID> channelIds =
        recipients.map((recipient) => recipient.channel);

    final List<ChannelTableData> channels =
        await channelAccessor.findManyByIds(channelIds);

    return channels.map(ChannelResponse.fromTableData);
  }

  @override
  Future<ChannelResponse> create(Request request) async {
    final ChannelCreateRequest payload =
        await request.body.as(ChannelCreateRequest.fromJson);

    late final ChannelTableData channel;

    switch (payload) {
      case NotesChannelCreateRequest():
        channel = await channelAccessor.insertOne(
          ChannelTableCompanion.insert(
            type: ChannelType.notes,
          ),
        );

        await recipientAccessor.insertOne(
          RecipientTableCompanion.insert(
            channel: channel.id,
            user: request.user.id,
          ),
        );

      case DirectChannelCreateRequest(:final FOxID recipient):
        channel = await channelAccessor.insertOne(
          ChannelTableCompanion.insert(
            type: ChannelType.direct,
          ),
        );

        await recipientAccessor.insertMany([
          RecipientTableCompanion.insert(
            channel: channel.id,
            user: request.user.id,
          ),
          RecipientTableCompanion.insert(
            channel: channel.id,
            user: recipient,
          ),
        ]);

      case GroupChannelCreateRequest(
          :final String? name,
          :final Set<FOxID>? recipients,
        ):
        channel = await channelAccessor.insertOne(
          ChannelTableCompanion.insert(
            type: ChannelType.group,
            name: Value.absentIfNull(name),
          ),
        );

        await recipientAccessor.insertManyOrIgnore([
          RecipientTableCompanion.insert(
            channel: channel.id,
            user: request.user.id,
          ),
          ...?recipients?.map(
            (recipient) => RecipientTableCompanion.insert(
              channel: channel.id,
              user: recipient,
            ),
          )
        ]);
    }

    return ChannelResponse.fromTableData(channel);
  }
}
