import 'dart:io';

import 'package:moments/features/posts/data/dto/post_dto.dart';
import 'package:moments/features/posts/data/model/post_api_model.dart';
import 'package:moments/features/posts/domain/entity/post_entity.dart';

abstract interface class IPostDataSource {
  Future<void> createPosts(PostEntity post);

  Future<List<String>> uploadImages(List<File> file);

  Future<dynamic> getPosts();

  Future<List<PostApiModel>> getPostsByUser();

  Future<PostDTO> getPostsByID(String id);

  Future<List<PostApiModel>> getPostsByUserID(String id);
}
