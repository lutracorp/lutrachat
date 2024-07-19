import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';

part 'logger.freezed.dart';
part 'logger.g.dart';

/// Log-related configuration.
@freezed
interface class LoggerConfiguration with _$LoggerConfiguration {
  const factory LoggerConfiguration({
    /// Minimum log level.
    @Default(Level.info) Level level,
  }) = _LoggerConfiguration;

  factory LoggerConfiguration.fromJson(Map<String, dynamic> json) =>
      _$LoggerConfigurationFromJson(json);
}
