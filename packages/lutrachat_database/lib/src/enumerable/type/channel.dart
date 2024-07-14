import 'package:freezed_annotation/freezed_annotation.dart';

/// Type of channel.
@JsonEnum(valueField: 'index')
enum ChannelType {
  /// A private channel for a single user.
  notes,

  /// A private channel between two users.
  direct,

  /// A private channel between multiple users.
  group,
}
