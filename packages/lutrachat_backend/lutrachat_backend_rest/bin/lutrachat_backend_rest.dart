import 'dart:io';

import 'package:args/args.dart';
import 'package:get_it/get_it.dart';
import 'package:lutrachat_backend_rest/lutrachat_backend_rest.dart';
import 'package:lutrachat_backend_server/lutrachat_backend_server.dart';
import 'package:yaml/yaml.dart';
import 'package:yaml_extension/yaml_extension.dart';

Future<void> main(List<String> arguments) async {
  final ArgParser argParser = ArgParser()
    ..addOption(
      'configFile',
      abbr: 'c',
      help: 'Path to configuration file in YAML format.',
      defaultsTo: './config.yaml',
    );

  final ArgResults results = argParser.parse(arguments);

  final File configFile = File(results.option('configFile')!);
  final String configContents = await configFile.readAsString();
  final YamlMap configYamlMap = loadYaml(configContents);
  final Map<String, dynamic> configMap = configYamlMap.toMap();

  final ApplicationConfiguration applicationConfiguration =
      ApplicationConfiguration.fromJson(configMap);

  final GetIt getIt = await applicationConfiguration.configureDependencies();

  await getIt.getAsync<ServerService>().then((server) async {
    await getIt.getAllAsync<ServerRoute>().then((routes) {
      routes.forEach(server.mount);
    });
  });
}
