import 'package:equatable/equatable.dart';

class PostEntity extends Equatable {
  final String? id;
  final String? user;
  final String? content;
  final List<String> image;

  PostEntity({
    this.id,
    this.user,
    this.content,
    required this.image,
  });

  @override
  List<Object?> get props => [id, user, content, image];
}
