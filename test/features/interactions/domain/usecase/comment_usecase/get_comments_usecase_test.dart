// test/features/conversation/domain/usecase/get_comments_usecase_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moments/features/interactions/data/dto/comment_dto.dart';
import 'package:moments/features/interactions/domain/usecase/comment_usecase/get_comments_usecase.dart';
import 'package:moments/features/interactions/data/repository/comment_remote_repository.dart';

/// Create a mock for CommentRemoteRepository.
class MockCommentRemoteRepository extends Mock implements CommentRemoteRepository {}

void main() {
  late GetCommentsUsecase usecase;
  late MockCommentRemoteRepository mockRepository;

  setUp(() {
    mockRepository = MockCommentRemoteRepository();
    usecase = GetCommentsUsecase(mockRepository);
  });

  final tId = 'post1';
  final tParams = GetCommentsParams(id: tId);

  // Create dummy UserDTO and CommentDTO.
  final dummyUser = UserDTO(
    userId: 'u1',
    username: 'TestUser',
    image: ['https://example.com/test.jpg'],
  );
  final dummyCommentDTO = CommentDTO(
    commentId: 'c1',
    post: tId,
    user: dummyUser,
    comment: 'Nice post!',
    createdAt: DateTime.now(),
  );

  final tCommentsList = [dummyCommentDTO];

  test('should return list of CommentDTO when repository.getComments() succeeds', () async {
    // Arrange: stub repository.getComments to return tCommentsList.
    when(() => mockRepository.getComments(tId))
        .thenAnswer((_) async => Right(tCommentsList));

    // Act: call the usecase.
    final result = await usecase.call(tParams);

    // Assert: result should be Right(tCommentsList)
    expect(result, Right(tCommentsList));
    verify(() => mockRepository.getComments(tId)).called(1);
  });
}
