// test/features/interactions/domain/usecase/delete_comment_usecase_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moments/features/interactions/domain/usecase/comment_usecase/delete_comment_usecase.dart';
import 'package:moments/features/interactions/data/repository/comment_remote_repository.dart';

/// Create a mock for CommentRemoteRepository.
class MockCommentRemoteRepository extends Mock implements CommentRemoteRepository {}

void main() {
  late DeleteCommentUsecase usecase;
  late MockCommentRemoteRepository mockRepository;

  setUp(() {
    mockRepository = MockCommentRemoteRepository();
    usecase = DeleteCommentUsecase(mockRepository);
  });

  final tCommentId = 'comment123';
  final tParams = DeleteCommentParams(id: tCommentId);

  test('should call repository.deleteComments with correct id and return Right(null)', () async {
    // Arrange: stub repository.deleteComments to return Right(null)
    when(() => mockRepository.deleteComments(tCommentId))
        .thenAnswer((_) async => Right(null));

    // Act: call the usecase.
    final result = await usecase.call(tParams);

    // Assert: the result should be Right(null)
    expect(result, Right(null));
    verify(() => mockRepository.deleteComments(tCommentId)).called(1);
  });
}
