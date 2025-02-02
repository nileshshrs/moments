import 'dart:io';

import 'package:dio/dio.dart';
import 'package:moments/app/constants/api_endpoints.dart';
import 'package:moments/features/posts/data/data_source/post_data_source.dart';
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
      if (response.statusCode == 200) {
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
}
