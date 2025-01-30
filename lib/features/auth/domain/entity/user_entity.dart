import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? userId;
  final String email;
  final String? fullname;
  final String username;
  final String? password;
  final bool? verified;
  final List<String>? image;  // Updated to List<String>?
  final String? bio;

  // Removed 'const' keyword from constructor
  const UserEntity({
    this.userId,
    required this.email,
    this.fullname,
    required this.username,
    this.password,
    this.verified,
    this.image,
    this.bio,
  });

  @override
  List<Object?> get props => [userId, username, email, image];  // Included image in the equality check
}
