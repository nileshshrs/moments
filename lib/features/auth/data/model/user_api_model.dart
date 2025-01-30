import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:moments/features/auth/domain/entity/user_entity.dart';

@JsonSerializable()
class UserModel extends Equatable {
  @JsonKey(name: '_id')
  final String? userId;
  final String email;
  final String? fullname;
  final String username;
  final String? password;
  final bool? verified;
  final List<String>? image; // Updated to List<String>?
  final String? bio;

  const UserModel({
    this.userId,
    required this.email,
    this.fullname,
    required this.username,
    this.password,
    this.verified,
    this.image,
    this.bio,
  });

  UserModel.empty()
      : userId = '',
        email = '',
        fullname = '',
        username = '',
        password = '',
        verified = false,
        image = [],
        bio = '';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['_id'] as String?,
      email: json['email'] as String,
      fullname: json['fullname'] as String?,
      username: json['username'] as String,
      password: json['password'] as String?,
      verified: json['verified'] as bool?,
      // Handling image as a List<String>
      image: json['image'] != null
          ? List<String>.from(
              json['image']) // Converts List<dynamic> to List<String>
          : null,
      bio: json['bio'] as String?,
    );
  }

  // Add toJson method for serializing the object to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': userId,
      'email': email,
      'fullname': fullname,
      'username': username,
      'password': password,
      'verified': verified,
      // Convert List<String> to List<dynamic> for JSON
      'image': image,
      'bio': bio,
    };
  }

  // Convert API Object to Entity
  UserEntity toEntity() => UserEntity(
        userId: userId,
        email: email,
        fullname: fullname,
        username: username,
        password: password,
        verified: verified,
        image: image, // Should be a List<String> in the entity as well
        bio: bio,
      );

  // Convert Entity to API Object
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      userId: entity.userId,
      email: entity.email,
      fullname: entity.fullname,
      username: entity.username,
      password: entity.password,
      verified: entity.verified,
      image: entity.image, // Should be a List<String> in the entity
      bio: entity.bio,
    );
  }

  // Convert API List to Entity List
  static List<UserEntity> toEntityList(List<UserModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  List<Object?> get props => [
        userId,
        email,
        fullname,
        username,
        password,
        verified,
        image,
        bio,
      ];
}
