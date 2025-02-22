import 'package:dio/dio.dart';
import 'package:moments/app/constants/api_endpoints.dart';
import 'package:moments/features/interactions/data/data_source/follow_datasource.dart';
import 'package:moments/features/interactions/data/dto/follow_dto.dart';

class FollowRemoteDatasource implements IFollowDatasource {
  final Dio _dio;
  FollowRemoteDatasource(this._dio);
  @override
  Future<List<FollowDTO>> getUserFollowers(String id) async {
    try {
      Response res = await _dio.get("${ApiEndpoints.getUserFollowers}/$id");

      if (res.statusCode == 200 || res.statusCode == 201) {
        List<dynamic> data = res.data;
        return data.map((json) => FollowDTO.fromJson(json)).toList();
      } else {
        throw Exception("Failed to fetch followers: ${res.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception("DioException: ${e.response?.data ?? e.message}");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  @override
  Future<List<FollowDTO>> getUserFollowings(String id) async {
    try {
      Response res = await _dio.get("${ApiEndpoints.getUserFollowings}/$id");

      if (res.statusCode == 200 || res.statusCode == 201) {
        List<dynamic> data = res.data;
        return data.map((json) => FollowDTO.fromJson(json)).toList();
      } else {
        throw Exception("Failed to fetch followers: ${res.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception("DioException: ${e.response?.data ?? e.message}");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
  @override
  Future<void> createFollow(String id) async {
    try {
      Response res = await _dio.post("${ApiEndpoints.createFollow}/$id");

      if (res.statusCode == 200 || res.statusCode == 201) {
        return;
      } else {
        throw Exception("Failed to fetch followers: ${res.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception("DioException: ${e.response?.data ?? e.message}");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
  
  @override
  Future<void> unfollowUser(String followerID, followingID) async{
   try {
      Response res = await _dio.delete(ApiEndpoints.unfollow, data: {
        "followerID": followerID,
        "followingID": followingID,
      });

      if (res.statusCode == 200 || res.statusCode == 201) {
        return;
      } else {
        throw Exception("Failed to fetch followers: ${res.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception("DioException: ${e.response?.data ?? e.message}");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
