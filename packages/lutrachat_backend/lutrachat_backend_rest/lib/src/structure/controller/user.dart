import 'package:shelf_plus/shelf_plus.dart';

import '../../model/http/common/user/response.dart';

/// A controller that performs user actions.
abstract interface class UserController {
  /// Returns the user object of the requester's account.
  Future<UserResponse> self(Request request);

  /// Returns a user object for a given user ID.
  Future<UserResponse> fetch(Request request, String userId);
}
