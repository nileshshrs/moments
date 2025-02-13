class ApiEndpoints {
  ApiEndpoints._();

  static const Duration connectionTimeout = Duration(seconds: 1000);
  static const Duration receiveTimeout = Duration(seconds: 1000);

  static const String baseUrl = "http://10.0.2.2:6278/api/v1/";
  //auth - login/ register page/ splash screen
  static const String login = "auth/mobile/sign-in";
  static const String register = "auth/sign-up";
  static const String refresh = "auth/mobile/refresh";

  //posts - home page
  static const String createPosts = "post/create";
  static const String getPosts = "post/mobile/get";

  // image - image upload in create post
  static const String upload = "upload/images";

  //users - search page
  static const String getAllUsers = "user/all";

  //account page
  static const String profile = "user/profile";
  static const String getPostsByUser = "post/getByUser";
  static const String updateProfile = "user/update";

  //add more later
}
