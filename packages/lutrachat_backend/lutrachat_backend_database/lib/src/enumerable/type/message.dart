import 'package:freezed_annotation/freezed_annotation.dart';

/// Type of message.
@JsonEnum(valueField: 'index')
enum MessageType {
  /// Just a simple text message.
  standard,
}
