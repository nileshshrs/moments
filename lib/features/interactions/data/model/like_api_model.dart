import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:moments/features/interactions/domain/entity/like_entity.dart';

@JsonSerializable()
class LikeModel extends Equatable {
  @JsonKey(name: '_id')
  final String? likeId;
  final String post;
  final String user;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const LikeModel({
    this.likeId,
    required this.post,
    required this.user,
    this.createdAt,
    this.updatedAt,
  });

  LikeModel.empty()
      : likeId = '',
        post = '',
        user = '',
        createdAt = null,
        updatedAt = null;

  factory LikeModel.fromJson(Map<String, dynamic> json) {
    return LikeModel(
      likeId: json['_id'] as String?,
      post: json['post'] as String,
      user: json['user'] as String,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': likeId,
      'post': post,
      'user': user,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Convert API Object to Entity
  LikeEntity toEntity() => LikeEntity(
        likeId: likeId,
        post: post,
        user: user,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  // Convert Entity to API Object
  factory LikeModel.fromEntity(LikeEntity entity) {
    return LikeModel(
      likeId: entity.likeId,
      post: entity.post,
      user: entity.user,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  // Convert API List to Entity List
  static List<LikeEntity> toEntityList(List<LikeModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  List<Object?> get props => [
        likeId,
        post,
        user,
        createdAt,
        updatedAt,
      ];
}
