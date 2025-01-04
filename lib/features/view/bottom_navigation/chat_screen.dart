import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> messages = [
    {
      'username': 'Alice',
      'message': 'Hey! How are you?',
      'image': 'https://randomuser.me/api/portraits/women/1.jpg',
    },
    {
      'username': 'Bob',
      'message': 'Are we still meeting later?',
      'image': 'https://randomuser.me/api/portraits/men/2.jpg',
    },
    {
      'username': 'Charlie',
      'message': 'Got your email, thanks!',
      'image': 'https://randomuser.me/api/portraits/men/3.jpg',
    },
    {
      'username': 'David',
      'message': 'Let\'s catch up soon!',
      'image': 'https://randomuser.me/api/portraits/men/4.jpg',
    },
    {
      'username': 'Eve',
      'message': 'Don\'t forget to reply!',
      'image': 'https://randomuser.me/api/portraits/women/5.jpg',
    },
  ];

  List<Map<String, String>> displayedMessages = [];

  @override
  void initState() {
    super.initState();
    displayedMessages = messages; // Initially display all messages
  }

  void _filterMessages(String query) {
    if (query.isEmpty) {
      setState(() {
        displayedMessages = messages; // Show all messages when query is empty
      });
    } else {
      setState(() {
        // Filter messages based only on the username
        displayedMessages = messages
            .where((message) => message['username']!
                .toLowerCase()
                .contains(query.toLowerCase())) // Only filter by username
            .toList();
      });
    }
  }

  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> messages = [
    {
      'username': 'Alice',
      'message': 'Hey! How are you?',
      'image': 'https://randomuser.me/api/portraits/women/1.jpg',
    },
    {
      'username': 'Bob',
      'message': 'Are we still meeting later?',
      'image': 'https://randomuser.me/api/portraits/men/2.jpg',
    },
    {
      'username': 'Charlie',
      'message': 'Got your email, thanks!',
      'image': 'https://randomuser.me/api/portraits/men/3.jpg',
    },
    {
      'username': 'David',
      'message': 'Let\'s catch up soon!',
      'image': 'https://randomuser.me/api/portraits/men/4.jpg',
    },
    {
      'username': 'Eve',
      'message': 'Don\'t forget to reply!',
      'image': 'https://randomuser.me/api/portraits/women/5.jpg',
    },
  ];

  List<Map<String, String>> displayedMessages = [];

  @override
  void initState() {
    super.initState();
    displayedMessages = messages; // Initially display all messages
  }

  void _filterMessages(String query) {
    if (query.isEmpty) {
      setState(() {
        displayedMessages = messages; // Show all messages when query is empty
      });
    } else {
      setState(() {
        // Filter messages based only on the username
        displayedMessages = messages
            .where((message) => message['username']!
                .toLowerCase()
                .contains(query.toLowerCase())) // Only filter by username
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // Search bar
          SizedBox(
            height: 40,
            child: TextField(
              controller: _searchController,
              onChanged: _filterMessages,
              decoration: InputDecoration(
                hintText: 'Search by Username',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            displayedMessages =
                                messages; // Reset to all messages
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20), // Space between search bar and list
          const SizedBox(
            width: double.infinity,
            child: Text(
              "Messages",
              style: TextStyle(
                  color: Color(0xFF63C57A), fontWeight: FontWeight.bold),
            ),
          ),
          // Displaying the messages with GestureDetector
          Expanded(
            child: ListView.builder(
              itemCount: displayedMessages.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Call _onMessageTap when a message is tapped
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(displayedMessages[index]['image']!),
                    ),
                    title: Text(displayedMessages[index]['username']!),
                    subtitle: Text(displayedMessages[index]['message']!),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
