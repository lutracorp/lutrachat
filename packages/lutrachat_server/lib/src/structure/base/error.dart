import 'package:recase/recase.dart';

/// A generic server error that can be thrown out.
base class ServerError<Type extends Enum> extends Error {
  /// Error type passed from enum.
  final Type type;

  ServerError(this.type);

  /// Code of the error.
  int get code => type.index;

  /// Kind of the error.
  String get kind => '$Type'.constantCase;

  @override
  String toString() => 'Generic error ($kind): code: $code';
}
