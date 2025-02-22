class ApiEndpoints {
  ApiEndpoints._();

  static const Duration connectionTimeout = Duration(seconds: 1000);
  static const Duration receiveTimeout = Duration(seconds: 1000);

  static const String baseUrl = "http://10.0.2.2:6278/api/v1/";
  // 192.168.31.172
  // http://10.0.2.2
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

  //conversation page
  static const String getConversation = "conversation/get";
  static const String createConversation = "conversation/mobile/create";
  static const String connections = "follow/connections";
  static const String updateConversation = "conversation/update";

  //message page
  static const String fetchMessages = "messages/conversation/get/";
  static const String createMessages = "messages/create/";

  //single posts
  static const String postByID = "/post/get";

  //likes
  static const String toggleLike = "/likes/toggle-likes";
  static const String getLikes = "/likes/likes-by-post";

  //comment
  static const String createComment = "comment/create";
  static const String getComments = "comment/get";
  static const String deleteComments = "comment/delete/";

  //user by id
  static const String getUserByID = "user/";

  //posts by user id
  static const String getPostsByUserID = "/post/get/user";

  //follow
  static const String getUserFollowers = "follow/get/followers";
  static const String getUserFollowings = "follow/get/following";
  static const String createFollow = "follow";
  static const String unfollow = "follow/unfollow";

  //notification
  static const String createNotification = "notification/create";
  static const String getNotification = "notification/all";
  static const String updateNotification = "notification/update";
  //add more later
}
