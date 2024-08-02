import 'package:foxid/foxid.dart';
import 'package:injectable/injectable.dart';
import 'package:lutrachat_backend_database/lutrachat_backend_database.dart';
import 'package:lutrachat_backend_server/lutrachat_backend_server.dart';
import 'package:shelf_plus/shelf_plus.dart';

import '../../../enumerable/error/channel.dart';
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
    final ChannelTableData? channelData =
        await channelAccessor.findOneByCanonicalId(channelId);

    if (channelData != null) {
      return ChannelResponse.fromTableData(channelData);
    }

    throw ServerError(ChannelErrorCode.notFound);
  }

  @override
  Future<Iterable<ChannelResponse>> list(Request request) async {
    final UserTableData user =
        request.context['lutrachat/user'] as UserTableData;

    final List<RecipientTableData> recipients =
        await recipientAccessor.findManyByUserId(user.id);

    final Iterable<FOxID> channelIds =
        recipients.map((recipient) => recipient.channel);

    final List<ChannelTableData> channels =
        await channelAccessor.findManyByIds(channelIds);

    return channels.map(ChannelResponse.fromTableData);
  }
}
