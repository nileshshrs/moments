import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moments/app/di/di.dart';
import 'package:moments/features/conversation/data/dto/connection_dto.dart';
import 'package:moments/features/conversation/presentation/view_model/conversation_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateConversation extends StatefulWidget {
  const CreateConversation({super.key});

  @override
  State<CreateConversation> createState() => _CreateConversationState();
}

class _CreateConversationState extends State<CreateConversation> {
  final TextEditingController _searchController = TextEditingController();
  List<ConnectionDTO> connections = [];
  String userID = "";

  @override
  void initState() {
    super.initState();
    _loadUserID();

    // Load connections only when this page opens
    Future.microtask(() {
      context.read<ConversationBloc>().add(LoadConnections());
    });

    _searchController.addListener(() {
      setState(() {}); // Force UI to rebuild on search input change
    });
  }

  Future<void> _loadUserID() async {
    final sharedPreferences = getIt<SharedPreferences>();
    setState(() {
      userID = sharedPreferences.getString('userID') ?? "";
    });
  }

  void _onUserSelected(ConnectionDTO connection) {
    print(
        'Creating conversation - User ID: $userID, Connection ID: ${connection.id}');

    if (userID.isNotEmpty) {
      context.read<ConversationBloc>().add(CreateConversations(
          connectionID: connection.id, userID: userID, context: context));
    }
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          children: [
            // Header Row
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 20,
                  ),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      "New message",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: SizedBox(
                height: 40,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by Username',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            // Connection List
            Expanded(
              child: BlocBuilder<ConversationBloc, ConversationState>(
                builder: (context, state) {
                  connections = state.connections ?? [];

                  // Filter connections based on search input
                  List<ConnectionDTO> filteredList = _searchController
                          .text.isEmpty
                      ? connections
                      : connections
                          .where((connection) => connection.username
                              .toLowerCase()
                              .contains(_searchController.text.toLowerCase()))
                          .toList();

                  if (state.isLoading) {
                    return SizedBox.shrink();
                  }

                  if (connections.isEmpty) {
                    return const Center(
                      child: Text(
                        'No users available',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final connection = filteredList[index];
                      return GestureDetector(
                        onTap: () => _onUserSelected(connection),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              connection.image.isNotEmpty
                                  ? connection.image.first
                                  : 'https://cvhrma.org/wp-content/uploads/2015/07/default-profile-photo.jpg',
                            ),
                          ),
                          title: Text(connection.username),
                          subtitle: Text(connection.email),
                          trailing: GestureDetector(
                            onTap: () => _onUserSelected(connection),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF63C57A),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                "Message",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
