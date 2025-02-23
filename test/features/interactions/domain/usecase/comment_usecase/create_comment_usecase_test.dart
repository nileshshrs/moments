// test/features/interactions/domain/usecase/create_comment_usecase_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moments/features/interactions/domain/entity/comment_entity.dart';
import 'package:moments/features/interactions/data/dto/comment_dto.dart';
import 'package:moments/features/interactions/data/repository/comment_remote_repository.dart';
import 'package:moments/features/interactions/domain/usecase/comment_usecase/create_comment_usecase.dart';

/// Create a mock for CommentRemoteRepository.
class MockCommentRemoteRepository extends Mock implements CommentRemoteRepository {}

/// Create a fake CommentEntity to serve as fallback.
class FakeCommentEntity extends Fake implements CommentEntity {}

void main() {
  // Register fallback value for CommentEntity.
  setUpAll(() {
    registerFallbackValue(FakeCommentEntity());
  });

  late CreateCommentUsecase usecase;
  late MockCommentRemoteRepository mockRepository;

  setUp(() {
    mockRepository = MockCommentRemoteRepository();
    usecase = CreateCommentUsecase(mockRepository);
  });

  final tPostID = 'post123';
  final tCommentText = 'Nice post!';
  final tParams = CreateCommentParams(postID: tPostID, comment: tCommentText);

  // Create a dummy CommentDTO that the repository should return.
  final tCommentDTO = CommentDTO(
    commentId: 'c1',
    post: tPostID,
    user: UserDTO(
      userId: 'user1',
      username: 'Alice',
      image: ['https://example.com/alice.jpg'],
    ),
    comment: tCommentText,
    createdAt: DateTime.now(),
  );

  test('should call repository.createComment with a proper CommentEntity and return CommentDTO', () async {
    // Arrange: stub repository.createComment to return tCommentDTO.
    when(() => mockRepository.createComment(any()))
        .thenAnswer((_) async => Right(tCommentDTO));

    // Act: call the usecase.
    final result = await usecase.call(tParams);

    // Assert: result should be Right(tCommentDTO).
    expect(result, Right(tCommentDTO));

    // Verify that createComment was called with a CommentEntity containing the correct values.
    verify(() => mockRepository.createComment(
          any(
            that: predicate<CommentEntity>((entity) {
              return entity.post == tPostID && entity.comment == tCommentText;
            }),
          ),
        )).called(1);
  });
}
