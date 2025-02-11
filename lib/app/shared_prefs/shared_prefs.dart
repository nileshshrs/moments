import 'package:dartz/dartz.dart';
import 'package:moments/core/error/failure.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  final SharedPreferences _sharedPreferences;

  SharedPrefs(this._sharedPreferences);

  Future<Either<Failure, void>> saveAccessToken(String accessToken) async {
    try {
      await _sharedPreferences.setString('accessToken', accessToken);
      return Right(null);
    } catch (e) {
      return Left(SharedPrefsFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, void>> saveRefreshToken(String refreshToken) async {
    try {
      await _sharedPreferences.setString('refreshToken', refreshToken);
      return Right(null);
    } catch (e) {
      return Left(SharedPrefsFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, String>> getAccessToken() async {
    try {
      final accessToken = _sharedPreferences.getString('accessToken');
      return Right(accessToken ?? "");
    } catch (e) {
      return Left(SharedPrefsFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, String>> getRefreshToken() async {
    try {
      final refreshToken = _sharedPreferences.getString('refreshToken');
      return Right(refreshToken ?? "");
    } catch (e) {
      return Left(SharedPrefsFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, void>> setUserID(String id) async {
    try {
      await _sharedPreferences.setString('userID', id);
      return Right(null);
    } catch (e) {
      return Left(SharedPrefsFailure(message: e.toString()));
    }
  }

  
  Future<Either<Failure, String>> getUserID() async {
    try {
      final userID = _sharedPreferences.getString('userID');
      return Right(userID ?? "");
    } catch (e) {
      return Left(SharedPrefsFailure(message: e.toString()));
    }
  }
}
