class ApiEndpoints {
  ApiEndpoints._();

  static const Duration connectionTimeout = Duration(seconds: 1000);
  static const Duration receiveTimeout = Duration(seconds: 1000);

  static const String baseUrl = "http://10.0.2.2:6278/api/v1/";

  static const String login = "auth/sign-in";
  static const String register = "auth/sign-up";

  //add more later
}
