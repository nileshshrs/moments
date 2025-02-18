part of 'post_bloc.dart';

sealed class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class CreatePost extends PostEvent {
  final BuildContext context;
  final String? content;
  final List<String> images;

  const CreatePost({
    required this.context,
    this.content,
    required this.images,
  });

  @override
  List<Object> get props => [];
}

class UploadImage extends PostEvent {
  final List<File> files;

  const UploadImage({required this.files});
}

class LoadPosts extends PostEvent {}

class LoadPostsByUser extends PostEvent {}

class LoadPostByID extends PostEvent {
  final String id;
  const LoadPostByID({required this.id});

  @override
  List<Object> get props => [id];
}
