import 'dart:io';

import 'package:dio/dio.dart';
import 'package:moments/app/constants/api_endpoints.dart';
import 'package:moments/features/posts/data/data_source/post_data_source.dart';
import 'package:moments/features/posts/data/dto/post_dto.dart';
import 'package:moments/features/posts/data/model/post_api_model.dart';
import 'package:moments/features/posts/domain/entity/post_entity.dart';

class PostRemoteDatasource implements IPostDataSource {
  final Dio _dio;

  PostRemoteDatasource(this._dio);
  @override
  Future<void> createPosts(PostEntity post) async {
    try {
      Response response = await _dio.post(ApiEndpoints.createPosts, data: {
        "content": post.content,
        "image": post.image,
      });
      if (response.statusCode == 201) {
        return;
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<String>> uploadImages(List<File> files) async {
    print("remote repository, $files");
    try {
      List<String> imageUrls = [];

      // Prepare the list of MultipartFile objects from the files
      List<MultipartFile> imageFiles = [];
      for (File file in files) {
        String fileName = file.path.split('/').last;
        imageFiles
            .add(await MultipartFile.fromFile(file.path, filename: fileName));
      }

      // Create the FormData with the list of files under the 'images' key
      FormData formData = FormData.fromMap({
        'images': imageFiles,
      });

      // Send the request with the entire list of files
      Response response = await _dio.post(
        ApiEndpoints.upload,
        data: formData,
      );

      if (response.statusCode == 200) {
        // Extract the filenames from the server response
        final List<dynamic> responseData =
            response.data['files']; // List of filenames
        for (var fileName in responseData) {
          imageUrls.add(fileName.toString());
        }

        return imageUrls;
      } else {
        throw Exception('Failed to upload images: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('DioException: $e');
    } catch (e) {
      throw Exception('Exception: $e');
    }
  }

  @override
  Future<List<PostDTO>> getPosts() async {
    try {
      // Making a GET request to fetch posts
      Response res = await _dio.get(
        ApiEndpoints.getPosts, // Define your endpoint in ApiEndpoints class
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        // If the request is successful, parse the response data
        List<dynamic> postsJson = res.data;
        // Convert the JSON data to a list of PostDTO objects
        List<PostDTO> posts =
            postsJson.map((json) => PostDTO.fromJson(json)).toList();
        return posts; // Return the parsed posts
      } else {
        // Handle errors if the status code is not 200
        throw Exception('Failed to load posts. Status code: ${res.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('DioException: $e');
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<PostApiModel>> getPostsByUser() async {
    try {
      Response res = await _dio.get(ApiEndpoints.getPostsByUser);
      if (res.statusCode == 200 || res.statusCode == 201) {
        List<dynamic> responseData = res.data;
        List<PostApiModel> posts = responseData
            .map((postJson) => PostApiModel.fromJson(postJson))
            .toList();

        return posts;
      } else {
        throw Exception('Failed to load posts. Status code: ${res.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('DioException: $e');
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<PostDTO> getPostsByID(String id) async {
    try {
      Response res = await _dio.get("${ApiEndpoints.postByID}/$id");
      if (res.statusCode == 200 || res.statusCode == 201) {
        return PostDTO.fromJson(res.data);
      } else {
        throw Exception('Failed to load post. Status code: \${res.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('DioException: \$e');
    } catch (e) {
      throw Exception('Unexpected error: \$e');
    }
  }
  
  @override
  Future<List<PostApiModel>> getPostsByUserID(String id) async{
 try {
      Response res = await _dio.get("${ApiEndpoints.getPostsByUserID}/$id");
      if (res.statusCode == 200 || res.statusCode == 201) {
        List<dynamic> responseData = res.data;
        List<PostApiModel> posts = responseData
            .map((postJson) => PostApiModel.fromJson(postJson))
            .toList();

        return posts;
      } else {
        throw Exception('Failed to load posts. Status code: ${res.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('DioException: $e');
    } catch (e) {
      throw Exception(e);
    }
  }
}
