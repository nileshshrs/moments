import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moments/app/di/di.dart';
import 'package:moments/core/utils/formatter.dart';
import 'package:moments/features/conversation/data/dto/conversation_dto.dart';
import 'package:moments/features/conversation/presentation/view/message_screen.dart';
import 'package:moments/features/conversation/presentation/view_model/conversation_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ConversationDto> displayedConversations = [];
  String currentUserId = "";
  late ConversationBloc conversationBloc; // Store ConversationBloc reference

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    conversationBloc = context
        .read<ConversationBloc>(); //Get Bloc once in a safe lifecycle method
    _fetchUserID();
    conversationBloc.add(LoadConversations()); //Fetch conversations
  }

  Future<void> _fetchUserID() async {
    final sharedPreferences =
        getIt<SharedPreferences>(); // Accessing SharedPreferences using getIt
    setState(() {
      currentUserId = sharedPreferences.getString('userID') ?? "";
    });
  }

  void _filterConversations(String query, List<ConversationDto> conversations) {
    setState(() {
      if (query.isEmpty) {
        displayedConversations = conversations;
      } else {
        displayedConversations = conversations
            .where((conversation) =>
                conversation.participants?.any((participant) =>
                    participant.username
                        ?.toLowerCase()
                        .contains(query.toLowerCase()) ??
                    false) ??
                false)
            .toList();
      }
    });
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
              onChanged: (query) {
                final state = conversationBloc.state;
                _filterConversations(query, state.conversation ?? []);
              },
              decoration: InputDecoration(
                hintText: 'Search by Username',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            final state = conversationBloc.state;
                            displayedConversations = state.conversation ?? [];
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

          // BlocListener to listen for conversation updates
          BlocListener<ConversationBloc, ConversationState>(
            listenWhen: (previous, current) =>
                previous.conversation != current.conversation,
            listener: (context, state) {
              setState(() {
                displayedConversations = state.conversation ?? [];
              });
            },
            child: Expanded(
              child: BlocBuilder<ConversationBloc, ConversationState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const SizedBox.shrink(); // Show loading indicator
                  }
                  if (state.conversation == null ||
                      state.conversation!.isEmpty) {
                    return const Center(child: Text("No conversations found"));
                  }

                  displayedConversations = state.conversation!;

                  return ListView.builder(
                    itemCount: displayedConversations.length,
                    itemBuilder: (context, index) {
                      final conversation = displayedConversations[index];

                      // Find the participant who is NOT the logged-in user
                      final otherParticipant =
                          conversation.participants?.firstWhere(
                        (participant) => participant.id != currentUserId,
                        orElse: () => conversation.participants!
                            .first, // Fallback if only one user exists
                      );

                      return GestureDetector(
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value:
                                    conversationBloc, //  Use stored reference instead of accessing context again
                                child:
                                    MessageScreen(conversation: conversation),
                              ),
                            ),
                          );

                          // Ensure ChatScreen refreshes when returning from MessageScreen
                          conversationBloc.add(LoadConversations());
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                otherParticipant?.image?.isNotEmpty == true
                                    ? otherParticipant!.image![0]
                                    : "https://via.placeholder.com/150"),
                          ),
                          title: Text(otherParticipant?.username ?? "Unknown"),
                          subtitle: Text(Formatter.shortenText(
                              conversation.lastMessage ?? "No messages yet")),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
