import 'package:equatable/equatable.dart';

class FollowEntity extends Equatable {
  final String? followId;
  final String follower;
  final String following;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const FollowEntity({
    this.followId,
    required this.follower,
    required this.following,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [followId, follower, following, createdAt, updatedAt];
}
