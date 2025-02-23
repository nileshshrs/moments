import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/posts/data/dto/post_dto.dart';
import 'package:moments/features/posts/domain/use_case/create_post_usecase.dart';
import 'package:moments/features/posts/domain/use_case/get_post_by_id_usecase.dart';
import 'package:moments/features/posts/domain/use_case/get_posts_usecase.dart';
import 'package:moments/features/posts/domain/use_case/upload_image_usecase.dart';
import 'package:moments/features/posts/presentation/view_model/post_bloc.dart';

class MockCreatePostsUsecase extends Mock implements CreatePostUsecase {}

class MockGetPostsUsecase extends Mock implements GetPostsUsecase {}

class MockUploadImageUsecase extends Mock implements UploadImageUsecase {}

class FakeUploadImageParams extends Mock implements UploadImageParams {}

class MockGetPostByIdUsecase extends Mock implements GetPostByIdUsecase {}

class MockBuildContext extends Mock implements BuildContext {}

class FakeCreatePostParams extends Fake implements CreatePostParams {}

void main() {
  late CreatePostUsecase createPostUsecase;
  late GetPostsUsecase getPostsUsecase;
  late UploadImageUsecase uploadImageUsecase;
  late PostBloc postBloc;
  late GetPostByIdUsecase getPostByIdUsecase;
  late MockBuildContext mockBuildContext;

  setUpAll(() {
    registerFallbackValue(FakeUploadImageParams()); //  Register fallback value
    registerFallbackValue(FakeCreatePostParams());
  });

  setUp(() {
    createPostUsecase = MockCreatePostsUsecase();
    getPostsUsecase = MockGetPostsUsecase();
    uploadImageUsecase = MockUploadImageUsecase();
    getPostByIdUsecase = MockGetPostByIdUsecase();
    mockBuildContext = MockBuildContext();
    postBloc = PostBloc(
      createPostUsecase: createPostUsecase,
      uploadImageUsecase: uploadImageUsecase,
      getPostUsecase: getPostsUsecase,
      getPostByIdUsecase: getPostByIdUsecase,
    );
  });
  tearDown(() {
    postBloc.close();
  });

  group('PostBloc', () {
    final postList = [
      PostDTO(
        id: "1",
        user: UserDTO(id: "10", username: "testuser", image: []),
        content: "Sample post 1",
        image: [],
        createdAt: "2024-02-07T12:00:00Z",
      ),
      PostDTO(
        id: "2",
        user: UserDTO(id: "11", username: "anotheruser", image: []),
        content: "Sample post 2",
        image: [],
        createdAt: "2024-02-07T13:00:00Z",
      ),
    ];

    final post = PostDTO(
      id: "1",
      user: UserDTO(id: "10", username: "testuser", image: []),
      content: "Sample post 1",
      image: [],
      createdAt: "2024-02-07T12:00:00Z",
    );

    const testContent = "Test Post";

    final testFiles = [
      File('test_image1.png'),
      File('test_image2.jpg'),
    ];
    final uploadedImageUrls = ['url1', 'url2']; // Mock uploaded image URLs
    blocTest<PostBloc, PostState>(
      'emits [loading state, success state with posts] when LoadPosts is added',
      build: () {
        when(() => getPostsUsecase.call())
            .thenAnswer((_) async => Right(postList));
        return postBloc;
      },
      act: (bloc) => bloc.add(LoadPosts()),
      expect: () => [
        // First, loading state
        postBloc.state.copyWith(
          isSuccess: false,
          posts: [],
        ),
        // Then, success state with posts
        postBloc.state.copyWith(
          isLoading: false,
          isSuccess: true,
          posts: postList,
        ),
      ],
    );

    blocTest<PostBloc, PostState>(
      'emits [failure] when CreatePost fails',
      build: () {
        when(() => createPostUsecase(any())).thenAnswer(
          (_) async => Left(
              ApiFailure(message: 'Something went wrong', statusCode: 400)),
        );
        return postBloc;
      },
      act: (bloc) {
        bloc.add(CreatePost(
          content: testContent,
          images: ["1", "2"],
          context: mockBuildContext,
        ));
      },
      expect: () => [
        postBloc.state.copyWith(
          isLoading: false, //  Match what Bloc actually emits
          isSuccess: false,
        ),
      ],
      verify: (_) {
        verify(() => createPostUsecase(any())).called(1);
      },
    );
    blocTest<PostBloc, PostState>(
      'emits [loading, failure] when UploadImage fails',
      build: () {
        when(() => uploadImageUsecase(any())).thenAnswer(
          (_) async =>
              Left(ApiFailure(message: 'Upload failed', statusCode: 500)),
        );
        return postBloc;
      },
      act: (bloc) {
        bloc.add(
            UploadImage(files: testFiles)); // ✅ Simulating image upload event
      },
      expect: () => [
        postBloc.state.copyWith(
          // ✅ First expected state (Loading)
          isLoading: true,
          isSuccess: false,
        ),
        postBloc.state.copyWith(
          // ✅ Second expected state (Failure)
          isLoading: false,
          isSuccess: false,
        ),
      ],
      verify: (_) {
        verify(() => uploadImageUsecase(any()))
            .called(1); // ✅ Ensures UploadImage was called
      },
    );
  });
  final post = PostDTO(
    id: "1",
    user: UserDTO(id: "10", username: "testuser", image: []),
    content: "Sample post 1",
    image: [],
    createdAt: "2024-02-07T12:00:00Z",
  );

  blocTest<PostBloc, PostState>(
    'emits [loading, failure] when LoadPostByID is added and getPostByIdUsecase fails',
    build: () {
      when(() => getPostByIdUsecase.call(any())).thenAnswer(
        (_) async =>
            Left(ApiFailure(message: 'Post not found', statusCode: 404)),
      );
      return postBloc;
    },
    act: (bloc) => bloc.add(LoadPostByID(id: "1")),
    expect: () => [
      // First state: loading started with post remaining null
      postBloc.state.copyWith(isLoading: true, isSuccess: false, post: null),
      // Second state: failure, so post remains unchanged (null)
      postBloc.state.copyWith(isLoading: false, isSuccess: false, post: null),
    ],
    verify: (_) {
      verify(() => getPostByIdUsecase.call(any())).called(1);
    },
  );
}
