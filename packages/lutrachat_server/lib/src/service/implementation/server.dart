import 'package:injectable/injectable.dart';
import 'package:lutrachat_common/lutrachat_common.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_plus/shelf_plus.dart';

import '../../configuration/server.dart';
import '../../structure/base/route.dart';
import '../../structure/middleware/error.dart';
import '../server.dart';

@LazySingleton(as: ServerService)
final class ServerServiceImplementation implements ServerService {
  /// Internal server router.
  final RouterPlus router = RouterPlus();

  /// Server-related configuration.
  final ServerConfiguration configuration;

  /// A service that provides logging.
  final LoggerService loggerService;

  /// Middleware for handling errors.
  final ErrorMiddleware errorMiddleware;

  ServerServiceImplementation(
    this.configuration,
    this.loggerService,
    this.errorMiddleware,
  );

  @override
  Future<void> mount(ServerRoute route) async {
    final Handler handler = await route.configure();

    router.mount(route.prefix, handler);

    loggerService.debug('Mounted ${route.prefix} route.');
  }

  @override
  @postConstruct
  Future<void> listen() async {
    final Handler handler =
        Pipeline().addMiddleware(errorMiddleware).addHandler(router);

    await serve(handler, configuration.address, configuration.port).then((_) {
      loggerService.debug("Started HTTP server on port ${configuration.port}.");
    });
  }
}
