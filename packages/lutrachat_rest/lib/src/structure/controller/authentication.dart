import 'package:shelf/shelf.dart';

import '../../model/http/authentication/login/response.dart';
import '../../model/http/authentication/register/response.dart';

/// A controller that performs user authentication.
abstract interface class AuthenticationController {
  /// Creates a new account and retrieves an authentication token for the given credentials.
  Future<RegisterResponse> register(Request request);

  /// Retrieves an authentication token for the given credentials.
  Future<LoginResponse> login(Request request);
}
