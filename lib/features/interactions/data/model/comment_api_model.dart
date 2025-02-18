import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:moments/features/interactions/domain/entity/comment_entity.dart';

@JsonSerializable()
class CommentModel extends Equatable {
  @JsonKey(name: '_id')
  final String? commentId;
  final String post;
  final String? user;
  final String comment;
  final DateTime? createdAt;

  const CommentModel({
    this.commentId,
    required this.post,
    this.user,
    required this.comment,
    this.createdAt,
  });

  const CommentModel.empty()
      : commentId = '',
        post = '',
        user = '',
        comment = '',
        createdAt = null;

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      commentId: json['_id'] as String?,
      post: json['post'] as String,
      user: json['user'] as String?,
      comment: json['comment'] as String,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': commentId,
      'post': post,
      'user': user,
      'comment': comment,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  // Convert API Object to Entity
  CommentEntity toEntity() => CommentEntity(
        commentId: commentId,
        post: post,
        user: user,
        comment: comment,
        createdAt: createdAt,
      );

  // Convert Entity to API Object
  factory CommentModel.fromEntity(CommentEntity entity) {
    return CommentModel(
      commentId: entity.commentId,
      post: entity.post,
      user: entity.user,
      comment: entity.comment,
      createdAt: entity.createdAt,
    );
  }

  // Convert API List to Entity List
  static List<CommentEntity> toEntityList(List<CommentModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  List<Object?> get props => [
        commentId,
        post,
        user,
        comment,
        createdAt,
      ];
}
