import 'package:json_annotation/json_annotation.dart';

part 'connection_dto.g.dart';

@JsonSerializable()
class ConnectionDTO {
  @JsonKey(name: "_id")
  final String id;
  final String email;
  final String username;
  final List<String> image; // Corrected to match API response

  ConnectionDTO({
    required this.id,
    required this.email,
    required this.username,
    required this.image,
  });

  factory ConnectionDTO.fromJson(Map<String, dynamic> json) =>
      _$ConnectionDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ConnectionDTOToJson(this);
}
