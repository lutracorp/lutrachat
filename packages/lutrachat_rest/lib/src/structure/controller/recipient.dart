import 'package:shelf_plus/shelf_plus.dart';

import '../../model/http/recipient/common/response.dart';

/// A controller that performs channel recipient actions.
abstract interface class RecipientController {
  /// Retrieves all recipients who are part of this channel.
  Future<Iterable<RecipientResponse>> list(Request request, String channelId);
}
