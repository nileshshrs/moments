import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:moments/app/di/di.dart';
import 'package:moments/core/utils/formatter.dart';
import 'package:moments/features/interactions/presentation/view_model/interactions_bloc.dart';
import 'package:moments/features/posts/presentation/view_model/post_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SinglePostScreen extends StatelessWidget {
  final String postId;

  const SinglePostScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    final sharedPreferences = getIt<SharedPreferences>();
    final String? userId = sharedPreferences.getString("userID");

    // Dispatch events only once using addPostFrameCallback to avoid multiple triggers
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostBloc>().add(LoadPostByID(id: postId));
      context.read<InteractionsBloc>().add(GetPostLikes(postID: postId));
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Post"),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        ),
      ),
      body: BlocBuilder<PostBloc, PostState>(
        builder: (context, postState) {
          if (postState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final post = postState.post;
          if (post == null) {
            return const Center(child: Text("Failed to load post"));
          }

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ Post Header (User Info)
                Row(
                  children: [
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF63C57A), width: 2),
                      ),
                      child: CircleAvatar(
                        radius: 10,
                        backgroundImage: NetworkImage(post.user.image[0]),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Formatter.capitalize(post.user.username),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          Formatter.formatTimeAgo(post.createdAt),
                          style: const TextStyle(fontWeight: FontWeight.w200),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // ✅ Post Content
                if (post.content.isNotEmpty)
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      post.content,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.left,
                    ),
                  ),
                const SizedBox(height: 8),

                // ✅ Post Image Handling
                if (post.image.isNotEmpty)
                  SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: (post.image.length > 1)
                        ? FlutterCarousel(
                            options: FlutterCarouselOptions(
                              height: MediaQuery.of(context).size.height * 0.6,
                              autoPlay: false,
                              showIndicator: true,
                              viewportFraction: 1.0,
                              slideIndicator: CircularSlideIndicator(
                                slideIndicatorOptions: SlideIndicatorOptions(
                                  indicatorRadius: 4,
                                  itemSpacing: 12,
                                ),
                              ),
                            ),
                            items: post.image.map((imageUrl) {
                              return Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(imageUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            }).toList(),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(post.image[0]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                  ),
                const SizedBox(height: 8),

                // ✅ Like & Comment Buttons with InteractionBloc
                BlocBuilder<InteractionsBloc, InteractionsState>(
                  builder: (context, likeState) {
                    if (likeState.isLoading) {
                      return const SizedBox.shrink(); // Hides UI until likes are loaded
                    }

                    final likeCount = likeState.likes[postId]?.likeCount ?? 0;
                    final userLiked = likeState.likes[postId]?.userLiked ?? false;

                    return Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (userId != null) {
                              context.read<InteractionsBloc>().add(
                                    ToggleLikes(userID: userId, postID: postId),
                                  );
                            }
                          },
                          icon: Icon(
                            CupertinoIcons.heart_fill,
                            color: userLiked ? Colors.red : Colors.grey,
                          ),
                        ),
                        Text(
                          likeCount.toString(),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          onPressed: () {
                            print("Commented");
                          },
                          icon: const Icon(
                            CupertinoIcons.conversation_bubble,
                            color: Colors.black,
                          ),
                        ),
                        const Text(
                          '45',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
