import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moments/features/auth/domain/entity/user_entity.dart';
import 'package:moments/features/interactions/presentation/view_model/interactions_bloc.dart';
import 'package:moments/features/profile/view/user_screen.dart';
import 'package:moments/features/profile/view_model/profile_bloc.dart';
import 'package:moments/features/search/view_model/search_bloc.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<UserEntity> users = [];
  List<UserEntity> filteredUsers = [];

  bool isSearchFieldEmpty() => _searchController.text.isEmpty;

  void _filterUser(String query) {
    if (query.isEmpty) {
      setState(() => filteredUsers = []);
      return;
    }
    setState(() {
      filteredUsers = users.where((user) {
        final username = user.username.toLowerCase();
        final email = user.email.toLowerCase();
        final searchQuery = query.toLowerCase();
        return username.contains(searchQuery) || email.contains(searchQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // Search bar with Clear button
          SizedBox(
            height: 35,
            child: TextField(
              controller: _searchController,
              onChanged: (query) {
                _filterUser(query);
              },
              decoration: InputDecoration(
                hintText: 'Search by Username or Email',
                prefixIcon: const Icon(Icons.search, color: Colors.black),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterUser(""); // Clear search results
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                hintStyle: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // User List (Only displays if search bar is not empty)
          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                users = state.users ?? [];

                // Show "No recent searches" message if search field is empty
                if (isSearchFieldEmpty()) {
                  return const Center(
                    child: Text(
                      'No recent searches',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                    ),
                  );
                }

                // Show "No users found" if search was performed but no results exist
                if (filteredUsers.isEmpty) {
                  return const Center(
                    child: Text(
                      'No users found',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                    ),
                  );
                }

                // Display filtered users
                return ListView.builder(
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = filteredUsers[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => MultiBlocProvider(
                              providers: [
                                BlocProvider.value(
                                    value: context.read<InteractionsBloc>()),
                                BlocProvider.value(
                                    value: context.read<ProfileBloc>()),
                              ],
                              child: UserScreen(userId: user.userId!),
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            (user.image != null && user.image!.isNotEmpty)
                                ? user.image![0]
                                : 'https://cvhrma.org/wp-content/uploads/2015/07/default-profile-photo.jpg',
                          ),
                        ),
                        title: Text(user.username),
                        subtitle: Text(user.email),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
