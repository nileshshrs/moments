import 'package:dartz/dartz.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/interactions/data/data_source/remote_data/notification_remote_datasource.dart';
import 'package:moments/features/interactions/data/dto/notification_dto.dart';
import 'package:moments/features/interactions/domain/entity/notification_entity.dart';
import 'package:moments/features/interactions/domain/repository/notification_repository.dart';

class NotificationRemoteRepository implements INotificationRepository {
  final NotificationRemoteDatasource _notificationRemoteDatasource;

  NotificationRemoteRepository(this._notificationRemoteDatasource);

  @override
  Future<Either<Failure, void>> createNotification(
      NotificationEntity notification) async {
    try {
      await _notificationRemoteDatasource.createNotification(notification);
      return const Right(
          null); // ✅ Ensure it correctly returns Right(null) on success
    } catch (e) {
      print("Notification API Failure: $e");
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<NotificationDTO>>> getAllNotification() async {
    try {
      final notification =
          await _notificationRemoteDatasource.getAllNotification();
      return Right(notification);
    } catch (e) {
      print("Notification API Failure: $e");
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateNotifications() async {
    try {
      await _notificationRemoteDatasource.updateNotifications();
      return const Right(
          null); // ✅ Ensure it correctly returns Right(null) on success
    } catch (e) {
      print("Notification API Failure: $e");
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
