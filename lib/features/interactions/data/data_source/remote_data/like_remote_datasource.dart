import 'package:dio/dio.dart';
import 'package:moments/app/constants/api_endpoints.dart';
import 'package:moments/features/interactions/data/data_source/like_datasource.dart';
import 'package:moments/features/interactions/domain/entity/like_entity.dart';

class LikeRemoteDatasource implements ILikeDatasource {
  final Dio _dio;

  LikeRemoteDatasource(this._dio);
  @override
  Future<void> toggleLikes(LikeEntity likes) async {
    try {
      Response res = await _dio.post(
        ApiEndpoints.toggleLike,
        data: {
          'userID': likes.user,
          'postID': likes.post,
        },
      );

      if (res.statusCode == 201 || res.statusCode == 200) {
        return;
      } else {
        throw Exception("Failed to toggle like: ${res.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception("DioException: ${e.response?.data ?? e.message}");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
