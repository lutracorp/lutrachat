import 'dart:async';

import '../../../gen/proto/google/protobuf/any.pb.dart';

/// Shortcut for [Any] protocol buffer [Stream].
typedef AnyStream = Stream<Any>;

/// Base class for broadcasting protocol buffers.
abstract base class Broadcast {
  /// Publishes the message.
  FutureOr<void> publish(Any message);

  /// Creates a stream returning messages.
  FutureOr<AnyStream> subscribe();
}
