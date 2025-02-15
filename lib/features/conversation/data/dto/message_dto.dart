import 'package:json_annotation/json_annotation.dart';

part 'message_dto.g.dart';

@JsonSerializable()
class MessageDTO {
  @JsonKey(name: "_id")
  final String? id;
  final String? conversation;
  final UserReference? sender;
  final UserReference? recipient;
  final String? content;

  MessageDTO({
    this.id,
    this.conversation,
    this.sender,
    this.recipient,
    this.content,
  });

  factory MessageDTO.fromJson(Map<String, dynamic> json) => _$MessageDTOFromJson(json);
  Map<String, dynamic> toJson() => _$MessageDTOToJson(this);
}

@JsonSerializable()
class UserReference {
  @JsonKey(name: "_id")
  final String? id;
  final String? username;
  final List<String>? image;

  UserReference({
    this.id,
    this.username,
    this.image,
  });

  factory UserReference.fromJson(Map<String, dynamic> json) =>
      _$UserReferenceFromJson(json);
  Map<String, dynamic> toJson() => _$UserReferenceToJson(this);
}
