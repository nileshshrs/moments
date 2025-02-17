import 'package:equatable/equatable.dart';

class LikeEntity extends Equatable {
  final String? likeId;
  final String post;
  final String user;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const LikeEntity({
    this.likeId,
    required this.post,
    required this.user,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        likeId,
        post,
        user,
        createdAt,
        updatedAt,
      ];
}
