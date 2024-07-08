import 'package:injectable/injectable.dart';
import 'package:lutrachat_common/lutrachat_common.dart';

@InjectableInit.microPackage(
  externalPackageModulesBefore: [
    ExternalModule(LutrachatCommonPackageModule)
  ]
)
export 'injectable.module.dart';
