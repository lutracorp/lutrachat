import 'package:injectable/injectable.dart';
import 'package:lutrachat_backend_database/lutrachat_backend_database.dart';
import 'package:lutrachat_backend_server/lutrachat_backend_server.dart';
import 'package:shelf_plus/shelf_plus.dart';

import '../../../model/http/common/recipient/response.dart';
import '../recipient.dart';

@LazySingleton(as: RecipientController)
final class RecipientControllerImplementation implements RecipientController {
  /// Data accessor for the channel recipients table.
  final RecipientAccessor recipientAccessor;

  RecipientControllerImplementation(this.recipientAccessor);

  @override
  Future<Iterable<RecipientResponse>> list(
    Request request,
    String _,
  ) async {
    final List<RecipientTableData> recipient =
        await recipientAccessor.findManyByChannelId(request.channel.id);

    return recipient.map(RecipientResponse.fromTableData);
  }
}
