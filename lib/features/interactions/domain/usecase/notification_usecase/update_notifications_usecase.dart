import 'package:dartz/dartz.dart';
import 'package:moments/app/usecase/usecase.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/interactions/data/repository/notification_remote_repository.dart';

class UpdateNotificationsUsecase implements UsecaseWithoutParams {
  final NotificationRemoteRepository repository;

  UpdateNotificationsUsecase(this.repository);
  @override
  Future<Either<Failure, dynamic>> call() {
    return repository.updateNotifications();
  }
}
