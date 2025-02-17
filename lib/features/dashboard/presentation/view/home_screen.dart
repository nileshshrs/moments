import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:moments/app/di/di.dart';
import 'package:moments/core/utils/formatter.dart';
import 'package:moments/features/interactions/presentation/view_model/interactions_bloc.dart';
import 'package:moments/features/posts/presentation/view/create_post/create_posts.dart';
import 'package:moments/features/posts/presentation/view_model/post_bloc.dart';
import 'package:moments/features/profile/view_model/profile_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sharedPreferences = getIt<SharedPreferences>();
    final String? userId = sharedPreferences.getString("userID");

    return MultiBlocListener(
      listeners: [
        BlocListener<PostBloc, PostState>(
          listenWhen: (previous, current) =>
              previous.isSuccess != current.isSuccess && current.isSuccess,
          listener: (context, state) {
            context.read<ProfileBloc>().add(LoadUserPosts());
          },
        ),
      ],
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.grey[900]!,
                              width: 0.4,
                            ),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (BuildContext bottomSheetContext) {
                                  return BlocProvider.value(
                                    value: context.read<PostBloc>(),
                                    child: CreatePostBottomSheet(),
                                  );
                                },
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0),
                              child: Text(
                                'What\'s on your mind...?',
                                style: TextStyle(fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // ✅ Posts Section
                BlocBuilder<PostBloc, PostState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * .5,
                        width: double.infinity,
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    } else if (state.posts == null || state.posts!.isEmpty) {
                      return const Center(child: Text("No posts as of currently."));
                    } else {
                      return Column(
                        children: state.posts!.map((post) {
                          context.read<InteractionsBloc>().add(GetPostLikes(postID: post.id));

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              children: [
                                // Post Header
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(post.user.image[0]),
                                      radius: 22,
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

                                // Post Content
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

                                // ✅ Post Image with Carousel
                                SizedBox(
                                  width: double.infinity,
                                  height: MediaQuery.of(context).size.height * 0.5,
                                  child: post.image.length > 1
                                      ? FlutterCarousel(
                                          options: FlutterCarouselOptions(
                                            height: MediaQuery.of(context).size.height * 0.5,
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

                                // ✅ Like & Comment Buttons
                                BlocBuilder<InteractionsBloc, InteractionsState>(
                                  buildWhen: (previous, current) =>
                                      previous.likes != current.likes, // ✅ Prevents unnecessary rebuilds
                                  builder: (context, likeState) {
                                    if (likeState.isLoading) {
                                      return const SizedBox.shrink(); // ✅ Prevents UI flicker
                                    }

                                    // ✅ Correctly get likes count
                                    final likeCount = likeState.likes[post.id]?.likeCount ?? 0;
                                    final userLiked = likeState.likes[post.id]?.userLiked ?? false;

                                    return Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            context.read<InteractionsBloc>().add(
                                                  ToggleLikes(
                                                    userID: userId!,
                                                    postID: post.id,
                                                  ),
                                                );
                                          },
                                          icon: Icon(
                                            CupertinoIcons.heart_fill,
                                            color: userLiked ? Colors.red : Colors.grey, // ✅ Correct like status
                                          ),
                                        ),
                                        Text(
                                          likeCount.toString(), // ✅ Correctly mapped like count
                                          style: const TextStyle(
                                              fontSize: 16, fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(width: 16),
                                        IconButton(
                                          onPressed: () {
                                            print("Commented");
                                            print(userId);
                                          },
                                          icon: const Icon(
                                            CupertinoIcons.conversation_bubble,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const Text(
                                          '45',
                                          style: TextStyle(
                                              fontSize: 16, fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
