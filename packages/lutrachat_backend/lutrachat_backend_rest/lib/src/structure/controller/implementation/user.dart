import 'package:injectable/injectable.dart';
import 'package:lutrachat_backend_database/lutrachat_backend_database.dart';
import 'package:lutrachat_backend_server/lutrachat_backend_server.dart';
import 'package:shelf_plus/shelf_plus.dart';

import '../../../model/http/common/user/response.dart';
import '../user.dart';

@LazySingleton(as: UserController)
final class UserControllerImplementation implements UserController {
  final UserAccessor userAccessor;

  UserControllerImplementation(this.userAccessor);

  @override
  Future<UserResponse> self(Request request) async {
    return UserResponse.fromTableData(request.user);
  }

  @override
  Future<UserResponse> fetch(Request request, String userId) async {
    final UserTableData? userData =
        await userAccessor.findOneByCanonicalId(userId);

    if (userData != null) {
      return UserResponse.fromTableData(userData);
    }

    throw ServerError(UserErrorCode.notFound);
  }
}
