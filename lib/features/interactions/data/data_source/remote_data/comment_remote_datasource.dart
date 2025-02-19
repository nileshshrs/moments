import 'package:dio/dio.dart';
import 'package:moments/app/constants/api_endpoints.dart';
import 'package:moments/features/interactions/data/data_source/comment_datasource.dart';
import 'package:moments/features/interactions/data/dto/comment_dto.dart';
import 'package:moments/features/interactions/domain/entity/comment_entity.dart';

class CommentRemoteDatasource implements ICommentDataSource {
  final Dio _dio;

  CommentRemoteDatasource(this._dio);

  @override
  Future<CommentDTO> createComment(CommentEntity comment) async {
    try {
      Response res = await _dio.post(
        ApiEndpoints.createComment,
        data: {"post": comment.post, "comment": comment.comment},
      );

      if (res.statusCode == 201 || res.statusCode == 200) {
        final Map<String, dynamic> responseData = res.data;
        final Map<String, dynamic> newCommentData =
            responseData['newComment']; // Extract newComment

        return CommentDTO.fromJson(newCommentData);
      } else {
        throw Exception("Failed to create comment: ${res.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception("DioException: ${e.response?.data ?? e.message}");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  @override
  Future<List<CommentDTO>> getComments(String id) async {
    try {
      Response res = await _dio.get(
        "${ApiEndpoints.getComments}/$id", // Corrected URL formatting
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        final List<dynamic> responseData =
            res.data; // Extract the list of comments
        return responseData
            .map((comment) => CommentDTO.fromJson(comment))
            .toList();
      } else {
        throw Exception("Failed to fetch comments: ${res.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception("DioException: ${e.response?.data ?? e.message}");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  @override
  Future<void> deleteComments(String id) async {
    try {
      Response res = await _dio.delete(
        "${ApiEndpoints.deleteComments}/$id", // Corrected URL formatting
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        return;
      } else {
        throw Exception("Failed to fetch comments: ${res.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception("DioException: ${e.response?.data ?? e.message}");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
