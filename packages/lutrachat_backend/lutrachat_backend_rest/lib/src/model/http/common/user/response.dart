import 'package:dartfield/dartfield.dart';
import 'package:foxid/foxid.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lutrachat_backend_database/lutrachat_backend_database.dart';

part 'response.freezed.dart';
part 'response.g.dart';

@freezed
interface class UserResponse with _$UserResponse {
  const factory UserResponse({
    /// The user's name.
    required FOxID id,

    /// The user's name.
    required String name,

    /// The type of the user.
    required UserType type,

    /// The flags on a user.
    required BitField flags,
  }) = _UserResponse;

  factory UserResponse.fromJson(Map<String, Object?> json) =>
      _$UserResponseFromJson(json);

  factory UserResponse.fromTableData(UserTableData data) => UserResponse(
        id: data.id,
        name: data.name,
        type: data.type,
        flags: data.flags,
      );
}
