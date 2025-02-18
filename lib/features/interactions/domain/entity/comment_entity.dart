import 'package:equatable/equatable.dart';

class CommentEntity extends Equatable {
  final String? commentId;
  final String post;
  final String? user;
  final String comment;
  final DateTime? createdAt;

  const CommentEntity({
    this.commentId,
    required this.post,
    this.user,
    required this.comment,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
        commentId,
        post,
        user,
        comment,
        createdAt,
      ];
}
