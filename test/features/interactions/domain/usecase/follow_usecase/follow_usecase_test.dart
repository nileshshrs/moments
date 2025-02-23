// test/features/interactions/domain/usecase/follow_usecases_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/interactions/data/dto/follow_dto.dart';
import 'package:moments/features/interactions/domain/usecase/follow_usecase/create_follow_usecase.dart';
import 'package:moments/features/interactions/domain/usecase/follow_usecase/get_followers_usecase.dart';
import 'package:moments/features/interactions/domain/usecase/follow_usecase/get_followings_usecase.dart';
import 'package:moments/features/interactions/domain/usecase/follow_usecase/unfollow_user_usecase.dart';
import 'package:moments/features/interactions/data/repository/follow_remote_repository.dart';

/// Create a mock for FollowRemoteRepository.
class MockFollowRemoteRepository extends Mock implements FollowRemoteRepository {}

void main() {
  late MockFollowRemoteRepository mockRepository;
  late CreateFollowUsecase createFollowUsecase;
  late GetFollowersUsecase getFollowersUsecase;
  late GetFollowingsUsecase getFollowingsUsecase;
  late UnfollowUserUsecase unfollowUserUsecase;

  setUp(() {
    mockRepository = MockFollowRemoteRepository();
    createFollowUsecase = CreateFollowUsecase(mockRepository);
    getFollowersUsecase = GetFollowersUsecase(mockRepository);
    getFollowingsUsecase = GetFollowingsUsecase(mockRepository);
    unfollowUserUsecase = UnfollowUserUsecase(mockRepository);
  });

  // Create dummy UserDTO objects.
  final dummyUserA = const UserDTO(
    id: 'user1',
    username: 'Alice',
    image: ['https://example.com/alice.jpg'],
    email: 'alice@example.com',
  );
  final dummyUserB = const UserDTO(
    id: 'user2',
    username: 'Bob',
    image: ['https://example.com/bob.jpg'],
    email: 'bob@example.com',
  );
  // Create a dummy FollowDTO.
  final dummyFollowDTO = FollowDTO(
    followId: 'f1',
    follower: dummyUserA,
    following: dummyUserB,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    match: false,
  );

  group('CreateFollowUsecase', () {
    final tId = 'user2';
    final tParams = CreateFollowParams(id: tId);

    test('should call repository.createFollow with correct id and return Right(null)', () async {
      // Arrange
      when(() => mockRepository.createFollow(tId))
          .thenAnswer((_) async => Right(null));
      
      // Act
      final result = await createFollowUsecase.call(tParams);
      
      // Assert
      expect(result, Right(null));
      verify(() => mockRepository.createFollow(tId)).called(1);
    });
  });

  group('GetFollowersUsecase', () {
    final tId = 'user1';
    final tParams = GetFollowerParams(id: tId);
    // Dummy followers list using FollowDTO.
    final tDummyFollowers = [dummyFollowDTO];

    test('should call repository.getUserFollowers with correct id and return Right(dummyFollowers)', () async {
      // Arrange
      when(() => mockRepository.getUserFollowers(tId))
          .thenAnswer((_) async => Right(tDummyFollowers));
      
      // Act
      final result = await getFollowersUsecase.call(tParams);
      
      // Assert
      expect(result, Right(tDummyFollowers));
      verify(() => mockRepository.getUserFollowers(tId)).called(1);
    });
  });

  group('GetFollowingsUsecase', () {
    final tId = 'user1';
    final tParams = GetFollowingParams(id: tId);
    // Dummy followings list using FollowDTO.
    final tDummyFollowings = [dummyFollowDTO];

    test('should call repository.getUserFollowings with correct id and return Right(dummyFollowings)', () async {
      // Arrange
      when(() => mockRepository.getUserFollowings(tId))
          .thenAnswer((_) async => Right(tDummyFollowings));
      
      // Act
      final result = await getFollowingsUsecase.call(tParams);
      
      // Assert
      expect(result, Right(tDummyFollowings));
      verify(() => mockRepository.getUserFollowings(tId)).called(1);
    });
  });

  group('UnfollowUserUsecase', () {
    final tFollowerID = 'user1';
    final tFollowingID = 'user2';
    final tParams = UnfollowUserParams(followerID: tFollowerID, followingID: tFollowingID);

    test('should call repository.unfollowUser with correct followerID and followingID and return Right(null)', () async {
      // Arrange
      when(() => mockRepository.unfollowUser(tFollowerID, tFollowingID))
          .thenAnswer((_) async => Right(null));
      
      // Act
      final result = await unfollowUserUsecase.call(tParams);
      
      // Assert
      expect(result, Right(null));
      verify(() => mockRepository.unfollowUser(tFollowerID, tFollowingID)).called(1);
    });
  });
}
