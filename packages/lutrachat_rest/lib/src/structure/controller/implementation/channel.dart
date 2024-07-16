import 'package:injectable/injectable.dart';
import 'package:lutrachat_database/lutrachat_database.dart';
import 'package:lutrachat_server/lutrachat_server.dart';
import 'package:shelf_plus/shelf_plus.dart';

import '../../../enumerable/error/channel.dart';
import '../../../model/http/channel/fetch/response.dart';
import '../channel.dart';

@LazySingleton(as: ChannelController)
final class ChannelControllerImplementation implements ChannelController {
  /// Data accessor for the channels table.
  final ChannelAccessor channelAccessor;

  ChannelControllerImplementation(this.channelAccessor);

  @override
  Future<ChannelFetchResponse> fetch(Request request, String channelId) async {
    final ChannelTableData? channelData =
        await channelAccessor.findByCanonicalId(channelId);

    if (channelData != null) {
      return ChannelFetchResponse.fromTableData(channelData);
    }

    throw ServerError(ChannelErrorCode.notFound);
  }
}
