import 'package:shelf_plus/shelf_plus.dart';

import '../../model/http/common/user/response.dart';

/// A controller that performs user actions.
abstract interface class UserController {
  ///
  Future<UserResponse> self(Request request);

  ///
  Future<UserResponse> fetch(Request request, String userId);
}
