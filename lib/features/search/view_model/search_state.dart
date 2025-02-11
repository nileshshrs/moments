part of 'search_bloc.dart';

class SearchState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final List<UserEntity>? users;
  final String? error;

  const SearchState({
    required this.isLoading,
    required this.isSuccess,
    this.users,
    this.error,
  });

  factory SearchState.initial() {
    return SearchState(
      isLoading: false,
      isSuccess: false,
      error: null,
      users: [],
    );
  }

  // Fixed copyWith method
  SearchState copyWith({
    bool? isLoading,
    bool? isSuccess,
    List<UserEntity>? users,
    String? error,
  }) {
    return SearchState(
      isLoading: isLoading ?? this.isLoading, // if null, keep current value
      isSuccess: isSuccess ?? this.isSuccess, // if null, keep current value
      users: users ?? this.users, // if null, keep current value
      error: error ?? this.error, // if null, keep current value
    );
  }

  @override
  List<Object?> get props => [isLoading, isSuccess, users, error];
}
