// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'like_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LikeDTO _$LikeDTOFromJson(Map<String, dynamic> json) => LikeDTO(
      likeCount: (json['likeCount'] as num).toInt(),
      userLiked: json['userLiked'] as bool,
    );

Map<String, dynamic> _$LikeDTOToJson(LikeDTO instance) => <String, dynamic>{
      'likeCount': instance.likeCount,
      'userLiked': instance.userLiked,
    };
