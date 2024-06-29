import 'package:freezed_annotation/freezed_annotation.dart';

part 'server.freezed.dart';
part 'server.g.dart';

/// Server-related configuration.
@freezed
interface class ServerConfiguration with _$ServerConfiguration {
  const factory ServerConfiguration({
    /// The address that the server is listening on.
    @Default('0.0.0.0') String address,

    /// The port that the server is listening on.
    @Default(8080) int port,
  }) = _ServerConfiguration;

  factory ServerConfiguration.fromJson(Map<String, dynamic> json) =>
      _$ServerConfigurationFromJson(json);
}
