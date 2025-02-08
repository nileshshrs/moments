import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/posts/domain/entity/post_entity.dart';
import 'package:moments/features/posts/domain/repository/post_repository.dart';
import 'package:moments/features/posts/domain/use_case/create_post_usecase.dart';

// Mock class for IPostRepository
class MockPostRepository extends Mock implements IPostRepository {}

void main() {
  late MockPostRepository mockPostRepository;
  late CreatePostUsecase createPostUsecase;

  // Register fallback value for PostEntity
  setUpAll(() {
    registerFallbackValue(PostEntity(content: 'test content', image: ['image1.jpg']));
  });

  setUp(() {
    mockPostRepository = MockPostRepository();
    createPostUsecase = CreatePostUsecase(mockPostRepository);
  });

  final tCreatePostParams = CreatePostParams(
    content: 'test content',
    image: ['image1.jpg', 'image2.jpg'],
  );

  final tPostEntity = PostEntity(
    content: tCreatePostParams.content,
    image: tCreatePostParams.image,
  );

  test('should create a post and return a success response', () async {
    // Arrange
    when(() => mockPostRepository.createPost(any()))
        .thenAnswer((_) async => const Right(null));

    // Act
    final result = await createPostUsecase(tCreatePostParams);

    // Assert
    expect(result, const Right(null));  // Expect success response (Right)
    verify(() => mockPostRepository.createPost(tPostEntity)).called(1);
    verifyNoMoreInteractions(mockPostRepository);
  });

  test('should return failure when post creation fails', () async {
    // Arrange
    final failure = ApiFailure(message: 'Error creating post', statusCode: 500);
    when(() => mockPostRepository.createPost(any())).thenAnswer(
      (_) async => Left(failure),
    );

    // Act
    final result = await createPostUsecase(tCreatePostParams);

    // Assert
    expect(result, Left<ApiFailure, void>(failure));  // Fix the expected type
  });
}
