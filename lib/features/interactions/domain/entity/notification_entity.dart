import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String? notificationId;
  final bool? read;
  final String recipient;
  final String? sender;
  final String? post;
  final String type;

  const NotificationEntity({
    this.notificationId,
    this.read,
    required this.recipient,
    this.sender,
    this.post,
    required this.type,
  });

  @override
  List<Object?> get props => [
        notificationId,
        read,
        recipient,
        sender,
        post,
        type,
      ];
}
