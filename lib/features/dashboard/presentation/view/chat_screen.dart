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
  List<ConversationDto> allConversations = []; // Store all conversations
  String currentUserId = "";
  late ConversationBloc conversationBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    conversationBloc = context.read<ConversationBloc>();
    _fetchUserID();
    conversationBloc.add(LoadConversations());
  }

  Future<void> _fetchUserID() async {
    final sharedPreferences = getIt<SharedPreferences>();
    setState(() {
      currentUserId = sharedPreferences.getString('userID') ?? "";
    });
  }

  void _filterConversations(String query) {
    setState(() {
      if (query.isEmpty) {
        displayedConversations = List.from(allConversations);
      } else {
        displayedConversations = allConversations
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
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: SizedBox(
              height: 40,
              child: TextField(
                controller: _searchController,
                onChanged: (query) {
                  _filterConversations(query);
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
                              _filterConversations("");
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
          ),
          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: const SizedBox(
              width: double.infinity,
              child: Text(
                "Messages",
                style: TextStyle(
                    color: Color(0xFF63C57A), fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // BlocListener to update conversations when fetched
          BlocListener<ConversationBloc, ConversationState>(
            listenWhen: (previous, current) =>
                previous.conversation != current.conversation,
            listener: (context, state) {
              setState(() {
                allConversations = state.conversation ?? [];
                displayedConversations = List.from(allConversations);
              });
            },
            child: Expanded(
              child: BlocBuilder<ConversationBloc, ConversationState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const SizedBox.shrink();
                  }
                  if (state.conversation == null ||
                      state.conversation!.isEmpty) {
                    return const Center(child: Text("No conversations found"));
                  }

                  return ListView.builder(
                    itemCount: displayedConversations.length,
                    itemBuilder: (context, index) {
                      final conversation = displayedConversations[index];

                      final otherParticipant =
                          conversation.participants?.firstWhere(
                        (participant) => participant.id != currentUserId,
                        orElse: () => conversation.participants!.first,
                      );

                      // ✅ Unread message logic remains the same
                      final bool isUnread = conversation.read == currentUserId;

                      return GestureDetector(
                        onTap: () async {
                          conversationBloc
                              .add(UpdateConversation(id: conversation.id!));
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: conversationBloc,
                                child:
                                    MessageScreen(conversation: conversation),
                              ),
                            ),
                          );

                          conversationBloc.add(LoadConversations());
                        },
                        child: Container(
                          color:
                              isUnread ? Colors.grey[200] : Colors.transparent,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  otherParticipant?.image?.isNotEmpty == true
                                      ? otherParticipant!.image![0]
                                      : "https://via.placeholder.com/150"),
                            ),
                            title: Text(
                              Formatter.capitalize(
                                  otherParticipant?.username ?? "Unknown"),
                              style: const TextStyle(
                                  fontWeight:
                                      FontWeight.bold), // **Bold usernames**
                            ),
                            subtitle: Text(
                              Formatter.shortenText(conversation.lastMessage ??
                                  "No messages yet"),
                              style: TextStyle(
                                fontWeight: isUnread
                                    ? FontWeight.w600
                                    : FontWeight
                                        .normal, // **Semi-bold unread messages**
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
          ),
        ],
      ),
    );
  }
}
