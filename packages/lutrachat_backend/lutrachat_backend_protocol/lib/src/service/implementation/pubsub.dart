import 'package:injectable/injectable.dart';
import 'package:protobuf/protobuf.dart';

import '../../../gen/proto/google/protobuf/any.pb.dart';
import '../../configuration/pubsub.dart';
import '../../structure/base/broadcast.dart';
import '../pubsub.dart';

@LazySingleton(as: PubSubService)
final class PubSubServiceImplementation implements PubSubService {
  /// Internal messages broadcast.
  final Broadcast broadcast;

  PubSubServiceImplementation(PubSubConfiguration configuration)
      : broadcast = configuration.broadcast.instance;

  @override
  Future<void> publish<T extends GeneratedMessage>(T message) async {
    final Any payload = Any.pack(message, typeUrlPrefix: 'type.lutracorp.su');

    return await broadcast.publish(payload);
  }

  @override
  Future<Stream<T>> subscribe<T extends GeneratedMessage>(T reference) async {
    final AnyStream stream = await broadcast.subscribe();

    return stream.where((message) => message.canUnpackInto(reference)).map(
          (message) => message.unpackInto(
            reference.createEmptyInstance() as T,
          ),
        );
  }
}
