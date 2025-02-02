import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:moments/features/posts/domain/entity/post_entity.dart';

@JsonSerializable()
class PostApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  final String? user;
  final String? content;
  final List<String> image;

  const PostApiModel({
    this.id,
    this.user,
    this.content,
    required this.image,
  });

  PostApiModel.empty()
      : id = '',
        user = '',
        content = '',
        image = [];

  factory PostApiModel.fromJson(Map<String, dynamic> json) {
    return PostApiModel(
      id: json['_id'] as String?,
      user: json['user'] as String?,
      content: json['content'] as String?,
      image: json['image'] != null
          ? List<String>.from(json['image'])
          : [], // Default to an empty list if 'image' is null
    );
  }

  PostEntity toEntity() =>
      PostEntity(id: id, user: user, content: content, image: image);

  factory PostApiModel.fromEntity(PostEntity entity) {
    return PostApiModel(
        id: entity.id,
        user: entity.user,
        content: entity.content,
        image: entity.image);
  }

  Map<String, dynamic> toJson() {
    return {"_id": id, "user": user, "content": content, "image": image};
  }

  @override
  List<Object?> get props => [id, user, content, image];
}
