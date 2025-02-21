import 'package:moments/features/auth/domain/entity/user_entity.dart';

abstract interface class IUserDataSource {
  Future<void> createUser(UserEntity userEntity);
  Future<List<UserEntity>> getAllUsers();
  Future<void> deleteUser(String id);
  Future<dynamic> login(String username, String password);
  Future<UserEntity> getUserProfile();
  Future<void> updateUser(UserEntity user);
  Future<UserEntity> getUserByID(String id);
}
