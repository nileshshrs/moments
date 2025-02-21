import 'package:moments/core/network/hive_service.dart';
import 'package:moments/features/auth/data/data_source/user_data_source.dart';
import 'package:moments/features/auth/data/model/user_hive_model.dart';
import 'package:moments/features/auth/domain/entity/user_entity.dart';

class UserLocalDatasource implements IUserDataSource {
  final HiveService _hiveService;

  UserLocalDatasource(this._hiveService);

  @override
  Future<void> createUser(UserEntity userEntity) async {
    try {
      final userHiveModel = UserHiveModel.fromEntity(userEntity);
      await _hiveService.addUser(userHiveModel);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> deleteUser(String id) async {
    try {
      return await _hiveService.deleteUser(id);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<UserEntity>> getAllUsers() async {
    try {
      return await _hiveService.getAllUsers().then((value) {
        return value.map((e) => e.toEntity()).toList();
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<UserEntity> login(String username, String password) async {
    try {
      final userHiveModel = await _hiveService.loginUser(username, password);
      if (userHiveModel == null ||
          userHiveModel.username.isEmpty ||
          (userHiveModel.password?.isEmpty ?? true)) {
        throw Exception("Invalid username or password");
      }
      return userHiveModel.toEntity();
    } catch (e) {
      throw Exception(e);
    }
  }
  
  @override
  Future<UserEntity> getUserProfile() {
    // TODO: implement getUserProfile
    throw UnimplementedError();
  }
  
  @override
  Future<void> updateUser(UserEntity user) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }

  @override
  Future<UserEntity> getUserByID(String id) {
    // TODO: implement getUserByID
    throw UnimplementedError();
  }
}
