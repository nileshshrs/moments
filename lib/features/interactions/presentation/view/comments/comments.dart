import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moments/app/di/di.dart';
import 'package:moments/core/utils/formatter.dart';
import 'package:moments/features/interactions/presentation/view_model/interactions_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommentScreen extends StatelessWidget {
  final String postId;

  const CommentScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    final sharedPreferences = getIt<SharedPreferences>();
    final String? userId = sharedPreferences.getString("userID");

    // Fetch comments
    context.read<InteractionsBloc>().add(FetchComments(postId: postId));

    final TextEditingController commentController = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          children: [
            // Header with back button and title
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade400,
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 20,
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Comments",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Comments List
            Expanded(
              child: BlocBuilder<InteractionsBloc, InteractionsState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.comments!.length,
                      itemBuilder: (context, index) {
                        final comment = state.comments![index];
                        String formattedTime = comment.createdAt != null
                            ? Formatter.formatTimeAgo(
                                comment.createdAt!.toIso8601String())
                            : "Unknown";

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.start, // Keeps avatar on top
                            children: [
                              // Circle Avatar
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: comment.user.image.isNotEmpty
                                    ? NetworkImage(comment.user.image.first)
                                    : null,
                                child: comment.user.image.isEmpty
                                    ? const Icon(Icons.person)
                                    : null,
                              ),
                              const SizedBox(
                                  width: 10), // Space between avatar and text

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Row for Username, Time, and Delete Button
                                    Row(
                                      children: [
                                        Expanded(
                                          child: RichText(
                                            text: TextSpan(
                                              style: const TextStyle(
                                                fontSize:
                                                    16, // Same size as comment
                                                color: Colors
                                                    .black, // Ensure text is visible
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: Formatter.capitalize(comment
                                                      .user
                                                      .username), // Bold username
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const TextSpan(
                                                  text: " • ", // Separator
                                                ),
                                                TextSpan(
                                                  text:
                                                      formattedTime, // Regular (not bold) time
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        // Delete Button (Only if userId matches)
                                        if (userId == comment.user.userId)
                                          IconButton(
                                            onPressed: () {
                                              context
                                                  .read<InteractionsBloc>()
                                                  .add(DeleteComment(
                                                      postId: comment.post,
                                                      commentId:
                                                          comment.commentId!));
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.grey,
                                              size: 18,
                                            ),
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                          ),
                                      ],
                                    ),

                                    // Comment Text
                                    Text(
                                      Formatter.shortenText(comment.comment,
                                          maxLength: 100),
                                      style: const TextStyle(
                                          fontSize: 16), // Same size as name
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),

            // Comment Input Field
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: commentController,
                decoration: InputDecoration(
                  hintText: "Add a comment...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: Color(0xFF63C57A),
                    ),
                    onPressed: () {
                      if (commentController.text.trim().isNotEmpty) {
                        context.read<InteractionsBloc>().add(
                              CreateComments(
                                postId: postId,
                                comment: commentController.text.trim(),
                              ),
                            );
                        commentController.clear();
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
