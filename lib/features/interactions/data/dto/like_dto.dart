import 'package:json_annotation/json_annotation.dart';

part 'like_dto.g.dart';

@JsonSerializable()
class LikeDTO {
  final int likeCount;
  final bool userLiked;

  LikeDTO({required this.likeCount, required this.userLiked});

  factory LikeDTO.fromJson(Map<String, dynamic> json) => _$LikeDTOFromJson(json);

  Map<String, dynamic> toJson() => _$LikeDTOToJson(this);
}
