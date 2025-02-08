import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:moments/features/posts/data/dto/post_dto.dart';
import 'package:moments/features/posts/domain/use_case/create_post_usecase.dart';
import 'package:moments/features/posts/domain/use_case/get_posts_usecase.dart';
import 'package:moments/features/posts/domain/use_case/upload_image_usecase.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final CreatePostUsecase _createPostUsecase;
  final UploadImageUsecase _uploadImageUsecase;
  final GetPostsUsecase _getPostsUsecase;

  PostBloc({
    required CreatePostUsecase createPostUsecase,
    required UploadImageUsecase uploadImageUsecase,
    required GetPostsUsecase getPostUsecase,
  })  : _uploadImageUsecase = uploadImageUsecase,
        _createPostUsecase = createPostUsecase,
        _getPostsUsecase = getPostUsecase,
        super(PostState.initial()) {
    on<CreatePost>(_createPosts);
    on<UploadImage>(_onLoadImage);
    on<LoadPosts>(_loadPosts);

    add(LoadPosts());
  }
  void _createPosts(CreatePost event, Emitter<PostState> emit) async {
    emit(state.copyWith(isLoading: true, isSuccess: false));
    print(state.images);
    final result = await _createPostUsecase
        .call(CreatePostParams(content: event.content, image: state.images!));

    result.fold(
      (failure) {
        // Handle failure case
        emit(state.copyWith(isLoading: false, isSuccess: false));
      },
      (_) {
        // Handle success case
        emit(state.copyWith(
          isLoading: false,
          isSuccess: true,
        ));
        add(LoadPosts());
      },
    );
  }

  void _onLoadImage(UploadImage event, Emitter<PostState> emit) async {
    emit(state.copyWith(isLoading: true, isSuccess: false));

    // Create the UploadImageParams with the list of files
    final params = UploadImageParams(files: event.files);

    // Call the use case with the params
    final result = await _uploadImageUsecase.call(params);

    result.fold(
      (failure) {
        // Handle failure case (show error or log)
        emit(state.copyWith(isLoading: false, isSuccess: false));
      },
      (imageUrls) {
        // Handle success case (update the state with the uploaded image URLs)
        emit(state.copyWith(
            isLoading: false, isSuccess: true, images: imageUrls));
      },
    );
  }

  Future<void> _loadPosts(LoadPosts event, Emitter<PostState> emit) async {
    // Set loading state and reset success/error
    emit(state.copyWith(isLoading: true, isSuccess: false));

    // Call use case to fetch posts
    final results = await _getPostsUsecase.call();

    // Unpack the result using fold and update the state accordingly
    results.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        isSuccess: false,
      )),
      (posts) {
        emit(state.copyWith(
          isLoading: false,
          isSuccess: true,
          posts: posts, // Update posts list when successful
        ));
      },
    );
  }
}
