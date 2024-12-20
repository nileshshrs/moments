import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController =
      TextEditingController(); // Controller for the search bar

  List<Map<String, String>> allUsers = [
    {
      'username': 'Alice',
      'email': 'alice@email.com',
      'image': 'https://randomuser.me/api/portraits/women/1.jpg',
    },
    {
      'username': 'Bob',
      'email': 'bob@email.com',
      'image': 'https://randomuser.me/api/portraits/men/2.jpg',
    },
    {
      'username': 'Charlie',
      'email': 'charlie@email.com',
      'image': 'https://randomuser.me/api/portraits/men/3.jpg',
    },
    {
      'username': 'David',
      'email': 'david@email.com',
      'image': 'https://randomuser.me/api/portraits/men/4.jpg',
    },
    {
      'username': 'Eve',
      'email': 'eve@email.com',
      'image': 'https://randomuser.me/api/portraits/women/5.jpg',
    },
    {
      'username': 'Frank',
      'email': 'frank@email.com',
      'image': 'https://randomuser.me/api/portraits/men/6.jpg',
    },
    {
      'username': 'Grace',
      'email': 'grace@email.com',
      'image': 'https://randomuser.me/api/portraits/women/7.jpg',
    },
    {
      'username': 'Hannah',
      'email': 'hannah@email.com',
      'image': 'https://randomuser.me/api/portraits/women/8.jpg',
    },
    {
      'username': 'Ivy',
      'email': 'ivy@email.com',
      'image': 'https://randomuser.me/api/portraits/women/9.jpg',
    },
    {
      'username': 'Jack',
      'email': 'jack@email.com',
      'image': 'https://randomuser.me/api/portraits/men/10.jpg',
    },
  ];

  List<Map<String, String>> displayedUsers =
      []; // Initialize with an empty list

  // Filter users based on the search query (search username or email)
  void _filterUsers(String query) {
    if (query.isEmpty) {
      // If the search query is empty, do not display anything
      setState(() {
        displayedUsers = [];
      });
    } else {
      List<Map<String, String>> filteredUsers = allUsers
          .where((user) =>
              user['username']!.toLowerCase().contains(query.toLowerCase()) ||
              user['email']!.toLowerCase().contains(query.toLowerCase()))
          .toList();

      setState(() {
        displayedUsers = filteredUsers;
      });
    }
  }

  // Clear the search field and reset the displayed users
  void _clearSearch() {
    _searchController.clear();
    _filterUsers('');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // Search bar with conditional Clear button
          SizedBox(
            height: 35,
            child: TextField(
              controller: _searchController,
              onChanged:
                  _filterUsers, // Call _filterUsers every time the input changes
              decoration: InputDecoration(
                hintText: 'Search by Username or Email',
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _clearSearch, // Clear search and reset users
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
          const SizedBox(height: 20), // Add some spacing

          // Show "No recent searches" message if the search field is empty
          if (displayedUsers.isEmpty && isSearchFieldEmpty())
            const Expanded(
              child: Center(
                child: Text(
                  'No recent searches',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

          // Only display the list if there are filtered users
          if (displayedUsers.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: displayedUsers.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(displayedUsers[index]['image']!),
                    ),
                    title: Text(displayedUsers[index]['username']!),
                    subtitle: Text(displayedUsers[index]['email']!),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  // Helper function to check if the search field is empty
  bool isSearchFieldEmpty() {
    return _searchController.text.isEmpty;
  }
}
