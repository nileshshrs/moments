import 'package:json_annotation/json_annotation.dart';
import 'package:moments/features/auth/data/model/user_api_model.dart';

part 'login_dto.g.dart';

@JsonSerializable()
class LoginDto {
  final String? message;
  final UserModel? user;
  final String? accessToken;
  final String? refreshToken;

  LoginDto({
    this.message,
    this.user,
    this.accessToken,
    this.refreshToken,
  });

  // Corrected to match the generated method name
  Map<String, dynamic> toJson() => _$LoginDtoToJson(this);

  // Fixed the factory method name and class name to match the class name
  factory LoginDto.fromJson(Map<String, dynamic> json) =>
      _$LoginDtoFromJson(json);
}
