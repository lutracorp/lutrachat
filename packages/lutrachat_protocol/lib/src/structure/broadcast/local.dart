import 'dart:async';

import '../../../gen/proto/google/protobuf/any.pb.dart';
import '../base/broadcast.dart';

/// A broadcast running in a local stream.
final class LocalBroadcast extends Broadcast {
  /// Internal broadcast controller.
  final StreamController<Any> controller = StreamController<Any>.broadcast();

  @override
  void publish(Any message) => controller.add(message);

  @override
  AnyStream subscribe() => Stream.castFrom(controller.stream);
}
