import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/posts/data/dto/post_dto.dart';
import 'package:moments/features/posts/domain/repository/post_repository.dart';
import 'package:moments/features/posts/domain/use_case/get_posts_usecase.dart';

// Mock class for IPostRepository
class MockPostRepository extends Mock implements IPostRepository {}

void main() {
  late MockPostRepository mockPostRepository;
  late GetPostsUsecase getPostsUsecase;

  // Register fallback value for PostDTO
  setUpAll(() {
    registerFallbackValue(PostDTO.fromJson({
      "_id": "1",
      "user": {"_id": "1", "username": "testuser", "image": ["image.jpg"]},
      "content": "Test post",
      "image": ["image.jpg"],
      "createdAt": "2022-01-01",
    }));
  });

  setUp(() {
    mockPostRepository = MockPostRepository();
    getPostsUsecase = GetPostsUsecase(mockPostRepository);
  });

  final tPostDTOList = [
    PostDTO.fromJson({
      "_id": "1",
      "user": {"_id": "1", "username": "testuser", "image": ["image1.jpg"]},
      "content": "Test post",
      "image": ["image1.jpg"],
      "createdAt": "2022-01-01",
    }),
    PostDTO.fromJson({
      "_id": "2",
      "user": {"_id": "2", "username": "anotheruser", "image": ["image2.jpg"]},
      "content": "Another test post",
      "image": ["image2.jpg"],
      "createdAt": "2022-01-02",
    }),
  ];

  test('should get posts successfully', () async {
    // Arrange
    when(() => mockPostRepository.getPosts())
        .thenAnswer((_) async => Right(tPostDTOList));

    // Act
    final result = await getPostsUsecase();

    // Assert
    expect(result, Right(tPostDTOList));  // Expect success response (Right)
    verify(() => mockPostRepository.getPosts()).called(1);
    verifyNoMoreInteractions(mockPostRepository);
  });

  test('should return failure when getting posts fails', () async {
    // Arrange
    final failure = ApiFailure(message: 'Error fetching posts', statusCode: 500);
    when(() => mockPostRepository.getPosts()).thenAnswer(
      (_) async => Left(failure),
    );

    // Act
    final result = await getPostsUsecase();

    // Assert
    expect(result, Left<ApiFailure, List<PostDTO>>(failure));  // Fix the expected type
  });
}
