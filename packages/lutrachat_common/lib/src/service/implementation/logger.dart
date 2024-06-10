import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import '../../configuration/logger.dart';
import '../logger.dart';

@LazySingleton(as: LoggerService)
final class LoggerServiceImplementation implements LoggerService {
  /// Of course, the backend of the logger.
  final Logger backend;

  LoggerServiceImplementation(LoggerConfiguration configuration)
      : backend = Logger(
          level: configuration.level,
          printer: SimplePrinter(),
          filter: ProductionFilter(),
        );

  @override
  void trace(message, {Object? error, StackTrace? stackTrace}) =>
      backend.t(message, error: error, stackTrace: stackTrace);

  @override
  void debug(message, {Object? error, StackTrace? stackTrace}) =>
      backend.d(message, error: error, stackTrace: stackTrace);

  @override
  void info(message, {Object? error, StackTrace? stackTrace}) =>
      backend.i(message, error: error, stackTrace: stackTrace);

  @override
  void warn(message, {Object? error, StackTrace? stackTrace}) =>
      backend.w(message, error: error, stackTrace: stackTrace);

  @override
  void error(message, {Object? error, StackTrace? stackTrace}) =>
      backend.e(message, error: error, stackTrace: stackTrace);

  @override
  void fatal(message, {Object? error, StackTrace? stackTrace}) =>
      backend.f(message, error: error, stackTrace: stackTrace);
}
