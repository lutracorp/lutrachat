import 'package:protobuf/protobuf.dart';

/// A service that provides PubSub capability.
abstract interface class PubSubService {
  /// Publishes the message.
  Future<void> publish<T extends GeneratedMessage>(T message);

  /// Creates a stream returning messages of specified type.
  Future<Stream<T>> subscribe<T extends GeneratedMessage>(T expected);
}
