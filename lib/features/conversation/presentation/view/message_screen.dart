import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moments/app/di/di.dart';
import 'package:moments/core/utils/formatter.dart';
import 'package:moments/features/conversation/data/dto/conversation_dto.dart';
import 'package:moments/features/conversation/data/dto/message_dto.dart';
import 'package:moments/features/conversation/presentation/view_model/conversation_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessageScreen extends StatelessWidget {
  final ConversationDto conversation;
  final TextEditingController _messageController = TextEditingController();

  MessageScreen({super.key, required this.conversation});

  void _sendMessage(BuildContext context) {
    final String messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    //  Dispatch event to send message
    // context.read<ConversationBloc>().add(SendMessage(
    //       conversationID: conversation.id!,
    //       content: messageText,
    //     ));

    //  Clear input field after sending
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final sharedPreferences = getIt<SharedPreferences>();
    final String currentUserId = sharedPreferences.getString('userID') ?? "";

    // Identify the receiver (the other participant)
    final receiver = conversation.participants?.firstWhere(
      (participant) => participant.id != currentUserId,
      orElse: () => conversation.participants!.first,
    );

    // Trigger `FetchMessage` event when the screen opens
    context
        .read<ConversationBloc>()
        .add(FetchMessage(conversationID: conversation.id!));

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes default back button
        leading: IconButton(
          //  Custom back button
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
          ),
        ),
        title: Text(
          Formatter.capitalize(receiver?.username ?? "Chat"),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: Column(
        children: [
          //  Chat Messages
          Expanded(
            child: BlocBuilder<ConversationBloc, ConversationState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.messages == null || state.messages!.isEmpty) {
                  return const Center(child: Text("No messages yet."));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: state.messages!.length,
                  itemBuilder: (context, index) {
                    final MessageDTO message = state.messages![index];

                    //  Check if the **current user** is the sender or recipient
                    final bool isMe = message.sender?.id == currentUserId;

                    //  Assign images correctly for sender & recipient
                    final String myImage = isMe
                        ? message.sender!.image!.first
                        : message.recipient!.image!.first;

                    final String otherImage = isMe
                        ? message.recipient!.image!.first
                        : message.sender!.image!.first;

                    return Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.end, //  Keep images at bottom
                      mainAxisAlignment: isMe
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        //  Recipient Image (Left Side)
                        if (!isMe)
                          Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(otherImage),
                            ),
                          ),

                        //  Message Bubble
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            decoration: BoxDecoration(
                              color: isMe
                                  ? const Color(0xFF63C57A)
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              message.content ?? "",
                              style: TextStyle(
                                  color: isMe ? Colors.white : Colors.black),
                            ),
                          ),
                        ),

                        //  Sender Image (Right Side)
                        if (isMe)
                          Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(myImage),
                            ),
                          ),
                      ],
                    );
                  },
                );
              },
            ),
          ),

          //  Input Field & Send Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
            child: Row(
              children: [
                //  Text Input (Fixed Height)
                Expanded(
                  child: SizedBox(
                    height: 40, //  Fixed height
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                //  Send Button (Same Height as TextField)
                SizedBox(
                  height: 40, //  Matches text field height
                  child: TextButton(
                    onPressed: () => _sendMessage(context),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF63C57A),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text(
                      "Send",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
