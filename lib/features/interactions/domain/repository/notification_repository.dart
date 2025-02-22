import 'package:dartz/dartz.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/interactions/data/dto/notification_dto.dart';
import 'package:moments/features/interactions/domain/entity/notification_entity.dart';

abstract interface class INotificationRepository {
  Future<Either<Failure, void>> createNotification(
      NotificationEntity notification);

  Future<Either<Failure, List<NotificationDTO>>> getAllNotification();
  Future<Either<Failure, void>> updateNotifications();
}
