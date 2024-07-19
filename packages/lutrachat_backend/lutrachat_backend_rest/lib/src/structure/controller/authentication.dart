import 'package:shelf/shelf.dart';

import '../../model/http/common/token/response.dart';

/// A controller that performs user authentication.
abstract interface class AuthenticationController {
  /// Creates a new account and retrieves an authentication token for the given credentials.
  Future<AuthenticationTokenResponse> register(Request request);

  /// Retrieves an authentication token for the given credentials.
  Future<AuthenticationTokenResponse> login(Request request);
}
