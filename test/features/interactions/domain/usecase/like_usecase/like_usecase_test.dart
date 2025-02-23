// test/features/interactions/domain/usecase/like_usecases_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/interactions/data/dto/like_dto.dart';
import 'package:moments/features/interactions/data/repository/like_remote_repository.dart';
import 'package:moments/features/interactions/domain/entity/like_entity.dart';
import 'package:moments/features/interactions/domain/usecase/like_usecase/get_likes_usecase.dart';
import 'package:moments/features/interactions/domain/usecase/like_usecase/toggle_like_usecase.dart';

/// Create a mock for LikeRemoteRepository.
class MockLikeRemoteRepository extends Mock implements LikeRemoteRepository {}

/// Create a fake for LikeEntity.
class FakeLikeEntity extends Fake implements LikeEntity {}

void main() {
  // Register fallback value for LikeEntity.
  setUpAll(() {
    registerFallbackValue(FakeLikeEntity());
  });

  late MockLikeRemoteRepository mockRepository;
  late GetLikesUsecase getLikesUsecase;
  late ToggleLikeUsecase toggleLikeUsecase;

  setUp(() {
    mockRepository = MockLikeRemoteRepository();
    getLikesUsecase = GetLikesUsecase(mockRepository);
    toggleLikeUsecase = ToggleLikeUsecase(mockRepository);
  });

  group('GetLikesUsecase', () {
    final tPostId = 'post1';
    final tParams = GetLikesParams(id: tPostId);

    // Create a dummy LikeDTO to be returned.
    final dummyLikeDTO = LikeDTO(likeCount: 10, userLiked: true);

    test('should return LikeDTO when repository.getPostLikes succeeds', () async {
      // Arrange
      when(() => mockRepository.getPostLikes(tPostId))
          .thenAnswer((_) async => Right(dummyLikeDTO));

      // Act
      final result = await getLikesUsecase.call(tParams);

      // Assert
      expect(result, Right(dummyLikeDTO));
      verify(() => mockRepository.getPostLikes(tPostId)).called(1);
    });
  });

  group('ToggleLikeUsecase', () {
    final tUserID = 'user1';
    final tPostID = 'post1';
    final tParams = ToggleLikeParams(userID: tUserID, postID: tPostID);

    test('should call repository.toggleLikes with proper LikeEntity and return Right(true)', () async {
      // Arrange: Stub repository.toggleLikes to return Right(true).
      when(() => mockRepository.toggleLikes(any()))
          .thenAnswer((_) async => Right(true));

      // Act
      final result = await toggleLikeUsecase.call(tParams);

      // Assert
      expect(result, Right(true));
      verify(() => mockRepository.toggleLikes(
            any(
              that: predicate<LikeEntity>((like) =>
                  like.post == tPostID && like.user == tUserID),
            ),
          )).called(1);
    });
  });
}
