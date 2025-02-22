import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moments/app/usecase/usecase.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/interactions/data/repository/notification_remote_repository.dart';
import 'package:moments/features/interactions/domain/entity/notification_entity.dart';

class CreateNotificationParams extends Equatable {
  final String recipient;
  final String type;
  final String? post;

  const CreateNotificationParams(
      {required this.recipient, required this.type, this.post});

  @override
  // TODO: implement props
  List<Object?> get props => [recipient, type, post];
}

class CreateNotificationUsecase implements UsecaseWithParams {
  final NotificationRemoteRepository repository;

  CreateNotificationUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(params) {
    final notification = NotificationEntity(
      read: false,
      recipient: params.recipient,
      type: params.type,
      post: params.post, // Ensures post is included only if not null
    );

    return repository.createNotification(notification);
  }
}
