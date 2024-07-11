/// A service that provides logging capability for all components.
abstract interface class LoggerService {
  /// Emits a message to the log with the trace level.
  void trace(dynamic message, [Object? error, StackTrace? stackTrace]);

  /// Emits a message to the log with the debug level.
  void debug(dynamic message, [Object? error, StackTrace? stackTrace]);

  /// Emits a message to the log with the info level.
  void info(dynamic message, [Object? error, StackTrace? stackTrace]);

  /// Emits a message to the log with the warn level.
  void warn(dynamic message, [Object? error, StackTrace? stackTrace]);

  /// Emits a message to the log with the error level.
  void error(dynamic message, [Object? error, StackTrace? stackTrace]);

  /// Emits a message to the log with the fatal level.
  void fatal(dynamic message, [Object? error, StackTrace? stackTrace]);
}
