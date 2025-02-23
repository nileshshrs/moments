// test/features/interactions/domain/usecase/notification_usecases_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/interactions/data/dto/notification_dto.dart';
import 'package:moments/features/interactions/data/repository/notification_remote_repository.dart';
import 'package:moments/features/interactions/domain/entity/notification_entity.dart';
import 'package:moments/features/interactions/domain/usecase/notification_usecase/create_notification_usecase.dart';
import 'package:moments/features/interactions/domain/usecase/notification_usecase/get_all_notification_usecase.dart';
import 'package:moments/features/interactions/domain/usecase/notification_usecase/update_notifications_usecase.dart';

/// Create a mock for NotificationRemoteRepository.
class MockNotificationRemoteRepository extends Mock
    implements NotificationRemoteRepository {}

/// Create a fake for NotificationEntity to serve as a fallback.
class FakeNotificationEntity extends Fake implements NotificationEntity {}

void main() {
  // Register fallback for NotificationEntity.
  setUpAll(() {
    registerFallbackValue(FakeNotificationEntity());
  });

  late MockNotificationRemoteRepository mockRepository;
  late CreateNotificationUsecase createNotificationUsecase;
  late GetAllNotificationUsecase getAllNotificationUsecase;
  late UpdateNotificationsUsecase updateNotificationsUsecase;

  setUp(() {
    mockRepository = MockNotificationRemoteRepository();
    createNotificationUsecase = CreateNotificationUsecase(mockRepository);
    getAllNotificationUsecase = GetAllNotificationUsecase(mockRepository);
    updateNotificationsUsecase = UpdateNotificationsUsecase(mockRepository);
  });

  group('CreateNotificationUsecase', () {
    final tRecipient = 'user2';
    final tType = 'like';
    final tPost = 'post1';
    final tParams = CreateNotificationParams(
      recipient: tRecipient,
      type: tType,
      post: tPost,
    );

    // Expected NotificationEntity is created inside the usecase with read: false.
    // For this test, we don't need to verify the inner details of the entity,
    // only that repository.createNotification is called with an entity having matching fields.
    test('should call repository.createNotification with correct NotificationEntity and return Right(null)', () async {
      // Arrange: Stub repository.createNotification to return Right(null).
      when(() => mockRepository.createNotification(any()))
          .thenAnswer((_) async => Right(null));
      
      // Act
      final result = await createNotificationUsecase.call(tParams);
      
      // Assert
      expect(result, Right(null));
      verify(() => mockRepository.createNotification(
            any(
              that: predicate<NotificationEntity>((entity) {
                return entity.read == false &&
                    entity.recipient == tRecipient &&
                    entity.type == tType &&
                    entity.post == tPost;
              }),
            ),
          )).called(1);
    });
  });

  group('GetAllNotificationUsecase', () {
    // Dummy list of NotificationDTO. Adjust fields as needed.
    final tNotifications = [
      NotificationDTO(
        notificationId: 'n1',
        read: false,
        recipient: 'user2',
        sender: SenderDTO(username: 'Alice', image: ['https://example.com/alice.jpg']),
        post: null,
        type: 'like',
      ),
      NotificationDTO(
        notificationId: 'n2',
        read: true,
        recipient: 'user2',
        sender: SenderDTO(username: 'Bob', image: ['https://example.com/bob.jpg']),
        type: 'comment',
      ),
    ];

    test('should return list of NotificationDTO when repository.getAllNotification succeeds', () async {
      // Arrange
      when(() => mockRepository.getAllNotification())
          .thenAnswer((_) async => Right(tNotifications));
      
      // Act
      final result = await getAllNotificationUsecase.call();
      
      // Assert
      expect(result, Right(tNotifications));
      verify(() => mockRepository.getAllNotification()).called(1);
    });
  });

  group('UpdateNotificationsUsecase', () {
    // For this test, assume that updateNotifications returns Right(null) on success.
    test('should call repository.updateNotifications and return Right(null)', () async {
      // Arrange
      when(() => mockRepository.updateNotifications())
          .thenAnswer((_) async => Right(null));
      
      // Act
      final result = await updateNotificationsUsecase.call();
      
      // Assert
      expect(result, Right(null));
      verify(() => mockRepository.updateNotifications()).called(1);
    });
  });
}
