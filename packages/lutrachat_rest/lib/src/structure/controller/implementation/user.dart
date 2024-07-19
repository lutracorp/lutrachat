import 'package:injectable/injectable.dart';
import 'package:lutrachat_database/lutrachat_database.dart';
import 'package:lutrachat_server/lutrachat_server.dart';
import 'package:shelf_plus/shelf_plus.dart';

import '../../../enumerable/error/user.dart';
import '../../../model/http/common/user/response.dart';
import '../user.dart';

@LazySingleton(as: UserController)
final class UserControllerImplementation implements UserController {
  final UserAccessor userAccessor;

  UserControllerImplementation(this.userAccessor);

  @override
  Future<UserResponse> self(Request request) async {
    final UserTableData user =
        request.context['lutrachat/user'] as UserTableData;

    return UserResponse.fromTableData(user);
  }

  @override
  Future<UserResponse> fetch(Request request, String userId) async {
    final UserTableData? userData =
        await userAccessor.findByCanonicalId(userId);

    if (userData != null) {
      return UserResponse.fromTableData(userData);
    }

    throw ServerError(UserErrorCode.notFound);
  }
}
