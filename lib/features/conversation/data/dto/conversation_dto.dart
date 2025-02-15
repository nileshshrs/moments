import 'package:json_annotation/json_annotation.dart';

part 'conversation_dto.g.dart';

@JsonSerializable()
class ConversationDto {
  @JsonKey(name: '_id')
  final String? id;
  final List<Participants>? participants;
  final String? lastMessage;
  final Participants? title;
  final String? read;

  ConversationDto({
    this.id,
    this.participants,
    this.lastMessage,
    this.title,
    this.read,
  });

  factory ConversationDto.fromJson(Map<String, dynamic> json) =>
      _$ConversationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationDtoToJson(this);
}

@JsonSerializable()
class Participants {
  @JsonKey(name: '_id')
  final String? id;
  final String? username;
  final List<String>? image;

  Participants({
    this.id,
    this.username,
    this.image,
  });

  factory Participants.fromJson(Map<String, dynamic> json) =>
      _$ParticipantsFromJson(json);

  Map<String, dynamic> toJson() => _$ParticipantsToJson(this);
}
