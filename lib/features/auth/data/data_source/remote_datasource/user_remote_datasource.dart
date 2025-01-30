import 'package:dio/dio.dart';
import 'package:moments/app/constants/api_endpoints.dart';
import 'package:moments/features/auth/data/data_source/user_data_source.dart';
import 'package:moments/features/auth/data/dto/login_dto.dart';
import 'package:moments/features/auth/data/model/user_api_model.dart';
import 'package:moments/features/auth/domain/entity/user_entity.dart';

class UserRemoteDatasource implements IUserDataSource {
  final Dio _dio;

  UserRemoteDatasource(this._dio);
  @override
  Future<void> createUser(UserEntity user) async {
    try {
      Response res = await _dio.post(
        ApiEndpoints.register,
        data: {
          'email': user.email,
          'username': user.username,
          'password': user.password
        },
      );

      if (res.statusCode == 201 || res.statusCode == 200) {
        return;
      } else {
        throw Exception(res.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> deleteUser(String id) {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  @override
  Future<List<UserEntity>> getAllUsers() {
    // TODO: implement getAllUsers
    throw UnimplementedError();
  }

  @override
  Future<LoginDto> login(String username, String password) async {
    try {
      Response res = await _dio.post(
        ApiEndpoints.login,
        data: {
          'usernameOrEmail': username,
          'password': password,
        },
      );

      if (res.statusCode == 201 || res.statusCode == 200) {
        final message = res.data['message'];
        final accessToken = res.data['accessToken'];
        final refreshToken = res.data['refreshToken'];
        final user = UserModel.fromJson(res.data['user']);

        // Return a LoginDto object with user, accessToken, and refreshToken
        return LoginDto(
          message: message,
          user: user,
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
      } else {
        throw Exception('Failed to login, status code: ${res.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(e);
    } catch (e) {
      throw Exception(e);
    }
  }
}
