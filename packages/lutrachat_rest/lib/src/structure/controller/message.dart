import 'package:shelf_plus/shelf_plus.dart';

import '../../model/http/message/common/response.dart';

/// A controller that performs message actions.
abstract interface class MessageController {
  /// Posts a message to a channel. Returns a message object on success.
  Future<MessageResponse> create(Request request, String target);

  /// Returns an array of message objects in the channel.
  Future<Iterable<MessageResponse>> list(Request request, String target);
}
