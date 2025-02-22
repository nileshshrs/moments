import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:moments/features/interactions/domain/entity/notification_entity.dart';

@JsonSerializable()
class NotificationModel extends Equatable {
  @JsonKey(name: '_id')
  final String? notificationId;
  final bool? read;
  final String recipient;
  final String? sender;
  final String? post;
  final String type;

  const NotificationModel({
    this.notificationId,
    this.read,
    required this.recipient,
    this.sender,
    this.post,
    required this.type,
  });

  const NotificationModel.empty()
      : notificationId = '',
        read = false,
        recipient = '',
        sender = '',
        post = null,
        type = '';

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notificationId: json['_id'] as String?,
      read: json['read'] as bool,
      recipient: json['recipient'] as String,
      sender: json['sender'] as String,
      post: json['post'] as String?,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': notificationId,
      'read': read,
      'recipient': recipient,
      'sender': sender,
      'post': post,
      'type': type,
    };
  }

  // Convert API Object to Entity
  NotificationEntity toEntity() => NotificationEntity(
        notificationId: notificationId,
        read: read,
        recipient: recipient,
        sender: sender,
        post: post,
        type: type,
      );

  // Convert Entity to API Object
  factory NotificationModel.fromEntity(NotificationEntity entity) {
    return NotificationModel(
      notificationId: entity.notificationId,
      read: entity.read,
      recipient: entity.recipient,
      sender: entity.sender,
      post: entity.post,
      type: entity.type,
    );
  }

  // Convert API List to Entity List
  static List<NotificationEntity> toEntityList(List<NotificationModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }

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
