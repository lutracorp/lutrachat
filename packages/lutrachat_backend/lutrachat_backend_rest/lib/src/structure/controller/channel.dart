import 'package:shelf_plus/shelf_plus.dart';

import '../../model/http/common/channel/response.dart';

/// A controller that performs channel actions.
abstract interface class ChannelController {
  /// Returns a channel object for a given channel ID.
  Future<ChannelResponse> fetch(Request request, String channelId);

  /// Returns a list of channel objects.
  Future<Iterable<ChannelResponse>> list(Request request);
}
