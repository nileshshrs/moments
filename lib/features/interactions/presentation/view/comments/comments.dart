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
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment
                                    .center, // Ensures avatar and text start from the top
                                children: [
                                  // Image Avatar Section
                                  SizedBox(
                                    width: 45, // Fixed width for avatar section
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundImage:
                                          comment.user.image.isNotEmpty
                                              ? NetworkImage(
                                                  comment.user.image.first)
                                              : null,
                                      child: comment.user.image.isEmpty
                                          ? const Icon(Icons.person)
                                          : null,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center, // Align username with avatar height
                                    children: [
                                      Text(
                                        Formatter.capitalize(
                                            comment.user.username),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                          width:
                                              5), // Small space between username and time
                                      Text(
                                        "• $formattedTime",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),

                                      // Delete Button (Only if userId matches)
                                      if (userId == comment.user.userId)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8),
                                          child: IconButton(
                                            onPressed: () {
                                              context
                                                  .read<InteractionsBloc>()
                                                  .add(
                                                    DeleteComment(
                                                      postId: comment.post,
                                                      commentId:
                                                          comment.commentId!,
                                                    ),
                                                  );
                                            },
                                            icon: const Icon(Icons.delete,
                                                color: Colors.grey, size: 18),
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                          ),
                                        ),
                                    ],
                                  ),

                                  const SizedBox(
                                      width:
                                          10), // Space between avatar and comment section

                                  // Comment + Username Section
                                ],
                              ),

                              // Username and Timestamp in the same row
                              // Minimal space between username and comment
                              const SizedBox(height: 2),

                              // Comment Text
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                width: double.infinity,
                                child: Text(
                                  Formatter.shortenText(comment.comment,
                                      maxLength: 500),
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
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
