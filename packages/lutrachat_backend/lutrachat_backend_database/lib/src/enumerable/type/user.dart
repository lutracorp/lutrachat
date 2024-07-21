import 'package:freezed_annotation/freezed_annotation.dart';

/// Type of user.
@JsonEnum(valueField: 'index')
enum UserType {
  /// Just a regular user.
  user,
}
