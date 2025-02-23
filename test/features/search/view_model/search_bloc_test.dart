// search_bloc_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/auth/domain/entity/user_entity.dart';
import 'package:moments/features/auth/domain/use_case/get_all_user_usecase.dart';
import 'package:moments/features/search/view_model/search_bloc.dart';

// Create a mock class for GetAllUserUsecase using mocktail.
class MockGetAllUserUsecase extends Mock implements GetAllUserUsecase {}

void main() {
  late MockGetAllUserUsecase mockGetAllUserUsecase;

  setUp(() {
    mockGetAllUserUsecase = MockGetAllUserUsecase();
  });

  group('SearchBloc', () {
    final tUsers = [
      const UserEntity(
        userId: '1',
        email: 'test@example.com',
        fullname: 'Test User',
        username: 'testuser',
        password: 'password',
        verified: true,
        image: ['image1.png'],
        bio: 'Test bio',
      )
    ];

    blocTest<SearchBloc, SearchState>(
      'emits [loading, success] when GetAllUserUsecase returns a list of users',
      build: () {
        when(() => mockGetAllUserUsecase.call())
            .thenAnswer((_) async => Right(tUsers));
        // The SearchBloc constructor dispatches LoadUsers automatically.
        return SearchBloc(getAllUserUsecase: mockGetAllUserUsecase);
      },
      // No act is needed since LoadUsers is added in the constructor.
      expect: () => [
        // First emitted state: loading.
        isA<SearchState>().having((s) => s.isLoading, 'isLoading', true),
        // Second emitted state: success with the list of users.
        isA<SearchState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.isSuccess, 'isSuccess', true)
            .having((s) => s.users, 'users', tUsers),
      ],
    );

    blocTest<SearchBloc, SearchState>(
      'emits [loading, failure] when GetAllUserUsecase returns a failure',
      build: () {
        when(() => mockGetAllUserUsecase.call()).thenAnswer(
          (_) async => Left(ApiFailure(message: 'Error occurred')),
        );
        return SearchBloc(getAllUserUsecase: mockGetAllUserUsecase);
      },
      expect: () => [
        isA<SearchState>().having((s) => s.isLoading, 'isLoading', true),
        isA<SearchState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.isSuccess, 'isSuccess', false),
      ],
    );
  });
}
