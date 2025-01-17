import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:moments/app/constants/hive_table_constants.dart';
import 'package:moments/features/auth/domain/entity/user_entity.dart';
import 'package:uuid/uuid.dart';

part 'user_hive_model.g.dart';
//dart run build_runner build -d

@HiveType(typeId: HiveTableConstant.userTableId)
class UserHiveModel extends Equatable {
  @HiveField(0)
  final String id; // Non-nullable, always assigned.

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String username;

  @HiveField(3)
  final String? image;

  @HiveField(4)
  final String? status;

  @HiveField(5)
  final bool verified; // Non-nullable, defaults to false.

  @HiveField(6)
  final String password;

  /// Main constructor
  UserHiveModel({
    String? id,
    required this.email,
    required this.username,
    this.image,
    this.status,
    bool? verified,
    required this.password,
  })  : id = id ?? const Uuid().v4(),
        verified = verified ?? false;

  /// Initial constructor with default values
  UserHiveModel.initial()
      : id = "",
        email = "",
        username = "",
        image ="",
        status = "",
        verified = false,
        password = "";

  /// Convert a `UserEntity` to a `UserHiveModel`
  factory UserHiveModel.fromEntity(UserEntity entity) {
    return UserHiveModel(
      id: entity.id ,
      email: entity.email,
      username: entity.username,
      image: entity.image,
      status: entity.status,
      verified: entity.verified,
      password: entity.password,
    );
  }

  /// Convert a list of `UserEntity` objects to a list of `UserHiveModel`.
  static List<UserHiveModel> fromEntityList(List<UserEntity> entityList) {
    return entityList.map((entity) => UserHiveModel.fromEntity(entity)).toList();
  }

  /// Convert a `UserHiveModel` back to a `UserEntity`.
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      username: username,
      image: image,
      status: status,
      verified: verified,
      password: password,
    );
  }

  @override
  List<Object?> get props =>
      [id, email, username, image, status, verified, password];
}
