part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {}

class LoadUserPosts extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final String email;
  final String username;
  final String? fullname;
  final List<String>? image;
  final String? bio;

  const UpdateProfile({
    required this.email,
    required this.username,
    this.fullname,
    this.image,
    this.bio,
  });

  @override
  List<Object?> get props => [email, username, fullname, image, bio];
}

class LoadProfileByID extends ProfileEvent {
  final String id;
  const LoadProfileByID({required this.id});

  @override
  List<Object> get props => [id];
}

class LoadPostsByUserID extends ProfileEvent {
  final String id;
  const LoadPostsByUserID({required this.id});

  @override
  List<Object> get props => [id];
}
