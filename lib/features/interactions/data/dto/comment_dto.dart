import 'package:json_annotation/json_annotation.dart';

part 'comment_dto.g.dart';

@JsonSerializable()
class CommentDTO {
  @JsonKey(name: '_id')
  final String? commentId;
  final String post;
  final UserDTO user;
  final String comment;
  final DateTime? createdAt;

  const CommentDTO({
    this.commentId,
    required this.post,
    required this.user,
    required this.comment,
    this.createdAt,
  });

  factory CommentDTO.fromJson(Map<String, dynamic> json) => _$CommentDTOFromJson(json);

  Map<String, dynamic> toJson() => _$CommentDTOToJson(this);
}

@JsonSerializable()
class UserDTO {
  @JsonKey(name: '_id')
  final String userId;
  final String username;
  final List<String> image; // Changed from String to List<String>

  const UserDTO({
    required this.userId,
    required this.username,
    required this.image,
  });

  factory UserDTO.fromJson(Map<String, dynamic> json) => _$UserDTOFromJson({
        ...json,
        'image': (json['image'] as List<dynamic>).map((e) => e as String).toList(), // Convert List<dynamic> to List<String>
      });

  Map<String, dynamic> toJson() => _$UserDTOToJson(this);
}
