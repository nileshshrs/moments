import 'package:dartz/dartz.dart';
import 'package:moments/app/usecase/usecase.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/interactions/data/dto/notification_dto.dart';
import 'package:moments/features/interactions/data/repository/notification_remote_repository.dart';

class GetAllNotificationUsecase implements UsecaseWithoutParams {
  final NotificationRemoteRepository repository;

  GetAllNotificationUsecase(this.repository);
  @override
  Future<Either<Failure, List<NotificationDTO>>> call() {
    return repository.getAllNotification();
  }
}
