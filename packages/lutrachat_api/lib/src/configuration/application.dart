import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:lutrachat_common/lutrachat_common.dart';
import 'package:lutrachat_database/lutrachat_database.dart';

import 'application.config.dart';

part 'application.freezed.dart';
part 'application.g.dart';

/// Configuration of all services required to run this application.
@freezed
@InjectableInit(externalPackageModulesBefore: [
  ExternalModule(LutrachatCommonPackageModule),
  ExternalModule(LutrachatDatabasePackageModule)
])
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
