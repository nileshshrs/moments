import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? id; 
  final String email; // Required String
  final String username; // Required String
  final String? image; // Nullable String
  final String? status; // Nullable String
  final bool? verified; // Non-nullable Boolean
  final String password; // Required String

  const UserEntity({
    this.id, // Ensure id is required
    required this.email,
    required this.username,
    this.image,
    this.status,
    bool?
        verified, // Nullable in UserEntity but will be assigned a default value in UserHiveModel
    required this.password,
  }) : verified = verified ?? false; // Default value for verified if not passed

  @override
  List<Object?> get props =>
      [id, email, username, image, status, verified, password];
}
