import 'package:dio/dio.dart';
import 'package:moments/app/constants/api_endpoints.dart';
import 'package:moments/app/di/di.dart';
import 'package:moments/app/shared_prefs/shared_prefs.dart';
import 'package:moments/core/error/dio_error_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiService {
  final Dio _dio;

  Dio get dio => _dio;

  ApiService(this._dio) {
    _initializeDio();
  }

  Future<void> _initializeDio() async {
    final sharedPrefs = getIt<SharedPrefs>();

    final accessTokenResult = await sharedPrefs.getAccessToken();
    final refreshTokenResult = await sharedPrefs.getRefreshToken();

    String? accessToken;
    String? refreshToken;

    accessTokenResult.fold(
      (failure) => print("Error fetching access token: ${failure.message}"),
      (token) => accessToken = token,
    );

    refreshTokenResult.fold(
      (failure) => print("Error fetching refresh token: ${failure.message}"),
      (token) => refreshToken = token,
    );

    _dio
      ..options.baseUrl = ApiEndpoints.baseUrl
      ..options.connectTimeout = ApiEndpoints.connectionTimeout
      ..options.receiveTimeout = ApiEndpoints.receiveTimeout
      ..interceptors.add(DioErrorInterceptor())
      ..interceptors.add(PrettyDioLogger(
          requestHeader: true, requestBody: true, responseHeader: true))
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            final updatedTokenResult = await sharedPrefs.getAccessToken();
            updatedTokenResult.fold(
              (failure) =>
                  print("Error fetching updated token: ${failure.message}"),
              (updatedToken) {
                if (updatedToken.isNotEmpty) {
                  options.headers['Authorization'] = 'Bearer $updatedToken';
                }
              },
            );

            return handler.next(options);
          },
          onError: (DioException error, handler) async {

            if (error.response?.statusCode == 401 &&
                error.response?.data?['errorCode'] == "InvalidAccessToken") {
              print("🔄 Access token expired, attempting to refresh token...");

              final newAccessToken = await _refreshAccessToken(refreshToken);
              if (newAccessToken != null) {
                print("✅ Access token refreshed successfully!");

                error.requestOptions.headers['Authorization'] =
                    'Bearer $newAccessToken';
                return handler.resolve(await _dio.fetch(error.requestOptions));
              }
            }
            return handler.next(error);
          },
        ),
      )
      ..options.headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if (accessToken != null && accessToken!.isNotEmpty)
          'Authorization': 'Bearer $accessToken',
      };
  }

  Future<String?> _refreshAccessToken(String? refreshToken) async {
    if (refreshToken == null || refreshToken.isEmpty) {
      print("No valid refresh token available.");
      return null;
    }

    print("Attempting to refresh access token...");
    print("Sending refresh token: $refreshToken");

    try {
      final dio = Dio(); // Using a new Dio instance to avoid global headers

      final response = await dio.get(
        "http://10.0.2.2:6278/api/v1/auth/mobile/refresh",
        options: Options(
          headers: {
            'Authorization': 'Bearer $refreshToken',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      print("Refresh token response received: ${response.data}");

      final newAccessToken = response.data['accessToken'];
      final newRefreshToken = response.data['refreshToken'] ?? refreshToken;

      if (newAccessToken == null || newAccessToken.isEmpty) {
        print("Received empty access token. Something is wrong.");
        return null;
      }

      final sharedPrefs = getIt<SharedPrefs>();
      await sharedPrefs.saveAccessToken(newAccessToken);
      await sharedPrefs.saveRefreshToken(newRefreshToken);

      print("New access token saved: $newAccessToken");
      print("New refresh token saved: $newRefreshToken");

      return newAccessToken;
    } catch (e) {
      print("Token refresh failed: $e");
      return null;
    }
  }
}
