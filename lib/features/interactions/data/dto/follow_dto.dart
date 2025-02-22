import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'follow_dto.g.dart';

@JsonSerializable()
class FollowDTO extends Equatable {
  @JsonKey(name: '_id')
  final String? followId;
  final UserDTO follower;
  final UserDTO following;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? match;

  const FollowDTO({
    this.followId,
    required this.follower,
    required this.following,
    this.createdAt,
    this.updatedAt,
    this.match
  });

  factory FollowDTO.fromJson(Map<String, dynamic> json) => _$FollowDTOFromJson(json);

  Map<String, dynamic> toJson() => _$FollowDTOToJson(this);

  @override
  List<Object?> get props => [followId, follower, following, createdAt, updatedAt];
}

@JsonSerializable()
class UserDTO extends Equatable {
   @JsonKey(name: '_id')
  final String? id;
  final String username;
  final List<String> image;
  final String email;

  const UserDTO({
    required this.id,
    required this.username,
    required this.image,
    required this.email,
  });

  factory UserDTO.fromJson(Map<String, dynamic> json) => _$UserDTOFromJson(json);

  Map<String, dynamic> toJson() => _$UserDTOToJson(this);

  @override
  List<Object?> get props => [id,username, image, email];
}