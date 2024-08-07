import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:lutrachat_backend_common/lutrachat_backend_common.dart';
import 'package:lutrachat_backend_database/lutrachat_backend_database.dart';
import 'package:lutrachat_backend_server/lutrachat_backend_server.dart';

import 'application.config.dart';

part 'application.freezed.dart';
part 'application.g.dart';

/// Configuration of all services required to run this application.
@freezed
@InjectableInit(
  externalPackageModulesBefore: [
    ExternalModule(LutrachatBackendCommonPackageModule),
    ExternalModule(LutrachatBackendDatabasePackageModule),
    ExternalModule(LutrachatBackendServerPackageModule)
  ],
  throwOnDuplicateDependencies: false,
)
interface class ApplicationConfiguration with _$ApplicationConfiguration {
  const ApplicationConfiguration._();

  const factory ApplicationConfiguration({
    required KDFConfiguration kdf,
    required LoggerConfiguration logger,
    required DatabaseConfiguration database,
    required ServerConfiguration server,
    required TokenConfiguration token,
  }) = _ApplicationConfiguration;

  Future<GetIt> configureDependencies() async {
    final GetIt instance = GetIt.instance
      ..enableRegisteringMultipleInstancesOfOneType()
      ..registerSingleton(kdf)
      ..registerSingleton(logger)
      ..registerSingleton(database)
      ..registerSingleton(server)
      ..registerSingleton(token);

    return await instance.init();
  }

  factory ApplicationConfiguration.fromJson(Map<String, dynamic> json) =>
      _$ApplicationConfigurationFromJson(json);
}
