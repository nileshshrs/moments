class ApiEndpoints {
  ApiEndpoints._();

  static const Duration connectionTimeout = Duration(seconds: 1000);
  static const Duration receiveTimeout = Duration(seconds: 1000);

  static const String baseUrl = "http://10.0.2.2:6278/api/v1/";
  //auth
  static const String login = "auth/mobile/sign-in";
  static const String register = "auth/sign-up";
  static const String refresh = "auth/mobile/refresh";

  //posts
  static const String createPosts = "post/create";
  static const String getPosts = "post/get";

  // image
  static const String upload = "upload/images";
  //add more later
}
