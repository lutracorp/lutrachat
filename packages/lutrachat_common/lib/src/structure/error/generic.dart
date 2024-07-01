import 'package:source_helper/source_helper.dart';

/// A generic error that can be thrown out.
final class GenericError<Type extends Enum> extends Error {
  /// Error type passed from enum.
  final Type type;

  /// Code of the error.
  int get code => type.index;

  /// Kind of the error.
  String get kind => Type.toString().snake.toUpperCase();

  GenericError(this.type);

  @override
  String toString() {
    return 'Generic error ($kind): code: $code';
  }
}
