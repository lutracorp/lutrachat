/// A generic error that can be thrown out.
final class GenericError<Type extends Enum> extends Error {
  /// Error type passed from enum.
  final Type? type;

  /// Code of the error.
  int get code => type?.index ?? -1;

  GenericError([this.type]);

  @override
  String toString() {
    return 'Generic error ($Type): code: $code';
  }
}
