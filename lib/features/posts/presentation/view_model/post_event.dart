part of 'post_bloc.dart';

sealed class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class CreatePost extends PostEvent {
  final BuildContext? context;
  final String? content;

  const CreatePost({
    this.context,
    this.content,
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