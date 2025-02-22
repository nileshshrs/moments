import 'package:moments/features/interactions/data/dto/notification_dto.dart';
import 'package:moments/features/interactions/domain/entity/notification_entity.dart';

abstract interface class INotificationDatasource {
  Future<void> createNotification(NotificationEntity notification);
  Future<List<NotificationDTO>> getAllNotification();
  Future<void> updateNotifications();
}
