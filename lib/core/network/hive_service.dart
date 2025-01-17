import 'package:hive_flutter/hive_flutter.dart';
import 'package:moments/app/constants/hive_table_constants.dart';
import 'package:moments/features/auth/data/model/user_hive_model.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  Future<void> init() async {
    // Correctly await the directory fetching
    var directory = await getApplicationDocumentsDirectory();

    // Define the path for the Hive database
    var path = '${directory.path}/moments.db';

    // Initialize Hive with the path
    Hive.init(path);

    Hive.registerAdapter(UserHiveModelAdapter());
  }

  Future<void> addUser(UserHiveModel user) async {
    var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    await box.put(user.id, user);
  }

  Future<void> deleteUser(String id) async {
    var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    await box.delete(id);
  }

  Future<List<UserHiveModel>> getAllUsers() async {
    var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    var users = box.values.toList();
    return users;
  }

  Future<UserHiveModel?> loginUser(String username, String password) async {
    var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    var auth = box.values.firstWhere(
        (element) =>
            element.username == username && element.password == password,
        orElse: () => UserHiveModel.initial());
    box.close();
    print(auth);
    return auth;
  }

  Future<void> clearUserBox() async {
    await Hive.deleteBoxFromDisk(HiveTableConstant.userBox);
  }

  Future<void> close() async {
    await Hive.close();
  }
}
