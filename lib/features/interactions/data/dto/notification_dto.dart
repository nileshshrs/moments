import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_dto.g.dart';

@JsonSerializable()
class NotificationDTO extends Equatable {
  @JsonKey(name: '_id')
  final String? notificationId;
  final bool read;
  final String recipient;
  final SenderDTO sender;
  final PostDTO? post;
  final String type;

  const NotificationDTO({
    this.notificationId,
    required this.read,
    required this.recipient,
    required this.sender,
    this.post,
    required this.type,
  });

  factory NotificationDTO.fromJson(Map<String, dynamic> json) =>
      _$NotificationDTOFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationDTOToJson(this);

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

@JsonSerializable()
class SenderDTO extends Equatable {
  final String username;
  final List<String> image; // ✅ Now correctly handles a list of images

  const SenderDTO({
    required this.username,
    required this.image,
  });

  factory SenderDTO.fromJson(Map<String, dynamic> json) {
    return SenderDTO(
      username: json['username'],
      image: (json['image'] as List<dynamic>).map((e) => e as String).toList(), // ✅ Convert dynamic list to List<String>
    );
  }

  Map<String, dynamic> toJson() => _$SenderDTOToJson(this);

  @override
  List<Object?> get props => [username, image];
}

@JsonSerializable()
class PostDTO extends Equatable {
  final List<String>? image;

  const PostDTO({
    this.image,
  });

  factory PostDTO.fromJson(Map<String, dynamic> json) =>
      _$PostDTOFromJson(json);

  Map<String, dynamic> toJson() => _$PostDTOToJson(this);

  @override
  List<Object?> get props => [image];
}
