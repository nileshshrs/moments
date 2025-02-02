import 'dart:io';

import 'package:moments/features/posts/domain/entity/post_entity.dart';

abstract interface class IPostDataSource {
  Future<void> createPosts(PostEntity post);

  Future<List<String>> uploadImages(List<File> file);
}
