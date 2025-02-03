import 'package:json_annotation/json_annotation.dart';

part 'post_dto.g.dart'; // This is the generated file

@JsonSerializable()
class PostDTO {
  @JsonKey(name: "_id")
  final String id;
  final UserDTO user;
  final String content;
  final List<String> image;
  final String createdAt;

  PostDTO({
    required this.id,
    required this.user,
    required this.content,
    required this.image,
    required this.createdAt
  });

  // Factory method to generate a PostDTO from JSON
  factory PostDTO.fromJson(Map<String, dynamic> json) =>
      _$PostDTOFromJson(json);

  // Method to generate JSON from a PostDTO
  Map<String, dynamic> toJson() => _$PostDTOToJson(this);
}

@JsonSerializable()
class UserDTO {
  @JsonKey(name: "_id")
  final String id;
  final String username;
  final List<String> image;

  UserDTO({
    required this.id,
    required this.username,
    required this.image,
  });

  // Factory method to generate a UserDTO from JSON
  factory UserDTO.fromJson(Map<String, dynamic> json) =>
      _$UserDTOFromJson(json);

  // Method to generate JSON from a UserDTO
  Map<String, dynamic> toJson() => _$UserDTOToJson(this);
}
