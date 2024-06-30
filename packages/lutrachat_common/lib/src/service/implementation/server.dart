import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_plus/shelf_plus.dart';

import '../../configuration/server.dart';
import '../../model/http/error/response.dart';
import '../../structure/error/generic.dart';
import '../logger.dart';
import '../server.dart';

@LazySingleton(as: ServerService)
final class ServerServiceImplementation implements ServerService {
  /// Server-related configuration.
  final ServerConfiguration configuration;

  /// A service that provides logging.
  final LoggerService loggerService;

  @override
  final RouterPlus router = RouterPlus();

  ServerServiceImplementation(this.configuration, this.loggerService);

  /// Handles errors from handlers.
  Response errorHandler(Object error, StackTrace stackTrace) {
    switch (error) {
      case GenericError(:final int code):
        return Response.badRequest(
          body: jsonEncode(
            ErrorResponse(code: code).toJson(),
          ),
        );
      default:
        return Response.internalServerError();
    }
  }

  @override
  @postConstruct
  Future<void> listen() async {
    loggerService.debug("Staring HTTP server on port ${configuration.port}.");

    final Middleware errorHandlerMiddleware =
        createMiddleware(errorHandler: errorHandler);

    final Handler handler =
        Pipeline().addMiddleware(errorHandlerMiddleware).addHandler(router);

    await serve(handler, configuration.address, configuration.port);
  }
}
