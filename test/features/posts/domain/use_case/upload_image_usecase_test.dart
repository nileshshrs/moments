import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/posts/domain/repository/post_repository.dart';
import 'package:moments/features/posts/domain/use_case/upload_image_usecase.dart';

class MockPostRepository extends Mock implements IPostRepository {}

void main() {
  late MockPostRepository mockPostRepository;
  late UploadImageUsecase uploadImageUsecase;

  setUp(() {
    mockPostRepository = MockPostRepository();
    uploadImageUsecase = UploadImageUsecase(mockPostRepository);
  });

  final tImageFiles = [File('path/to/image1.jpg'), File('path/to/image2.jpg')];
  final tImageUrls = ['https://image1.com', 'https://image2.com'];

  test('should upload images successfully and return image URLs', () async {
    // Arrange
    when(() => mockPostRepository.uploadImage(any()))
        .thenAnswer((_) async => Right(tImageUrls));

    final uploadParams = UploadImageParams(files: tImageFiles);

    // Act
    final result = await uploadImageUsecase(uploadParams);

    // Assert
    expect(result, Right(tImageUrls));  // Expect success response (Right)
    verify(() => mockPostRepository.uploadImage(tImageFiles)).called(1);
    verifyNoMoreInteractions(mockPostRepository);
  });

  test('should return failure when image upload fails', () async {
    // Arrange
    final failure = ApiFailure(message: 'Error uploading images', statusCode: 500);
    when(() => mockPostRepository.uploadImage(any()))
        .thenAnswer((_) async => Left(failure));

    final uploadParams = UploadImageParams(files: tImageFiles);

    // Act
    final result = await uploadImageUsecase(uploadParams);

    // Assert
    expect(result, Left<ApiFailure, List<String>>(failure));  // Fix the expected type
  });
}
