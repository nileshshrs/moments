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
  final List<String>? image; // Updated to List<String>? (nullable)

  @HiveField(4)
  final String? bio;

  @HiveField(5)
  final bool verified; // Non-nullable, defaults to false.

  @HiveField(6)
  final String? password;

  @HiveField(7)
  final String? fullname; // Newly added field

  /// Main constructor
  UserHiveModel({
    String? id,
    required this.email,
    required this.username,
    this.image,
    this.bio,
    bool? verified,
    this.password,
    this.fullname, // Optional field
  })  : id = id ?? const Uuid().v4(),
        verified = verified ?? false;

  /// Initial constructor with default values
  UserHiveModel.initial()
      : id = "",
        email = "",
        username = "",
        image = [],
        bio = "",
        verified = false,
        password = "",
        fullname = "";

  /// Convert a `UserEntity` to a `UserHiveModel`
  factory UserHiveModel.fromEntity(UserEntity entity) {
    return UserHiveModel(
      id: entity.userId,
      email: entity.email,
      username: entity.username,
      image: entity.image, // Image should be a List<String> in the entity
      bio: entity.bio,
      verified: entity.verified,
      password: entity.password,
      fullname: entity.fullname, // Map fullname field
    );
  }

  /// Convert a list of `UserEntity` objects to a list of `UserHiveModel`.
  static List<UserHiveModel> fromEntityList(List<UserEntity> entityList) {
    return entityList
        .map((entity) => UserHiveModel.fromEntity(entity))
        .toList();
  }

  /// Convert a `UserHiveModel` back to a `UserEntity`.
  UserEntity toEntity() {
    return UserEntity(
      userId: id,
      email: email,
      username: username,
      image: image, // Image should be a List<String> in the entity
      bio: bio,
      verified: verified,
      password: password,
      fullname: fullname, // Map fullname field
    );
  }

  @override
  List<Object?> get props =>
      [id, email, username, image, bio, verified, password, fullname];
}
