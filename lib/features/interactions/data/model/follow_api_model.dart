import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';


@JsonSerializable()
class FollowModel extends Equatable {
  @JsonKey(name: '_id')
  final String? followId;
  final String follower;
  final String following;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const FollowModel({
    this.followId,
    required this.follower,
    required this.following,
    this.createdAt,
    this.updatedAt,
  });

  FollowModel.empty()
      : followId = '',
        follower = '',
        following = '',
        createdAt = null,
        updatedAt = null;

  factory FollowModel.fromJson(Map<String, dynamic> json) {
    return FollowModel(
      followId: json['_id'] as String?,
      follower: json['follower'] as String,
      following: json['following'] as String,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': followId,
      'follower': follower,
      'following': following,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [followId, follower, following, createdAt, updatedAt];
}
