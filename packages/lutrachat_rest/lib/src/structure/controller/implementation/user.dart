import 'package:injectable/injectable.dart';

import '../user.dart';

@LazySingleton(as: UserController)
final class UserControllerImplementation implements UserController {
  UserControllerImplementation();
}
