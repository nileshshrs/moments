import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:moments/app/di/di.dart';
import 'package:moments/core/utils/formatter.dart';
import 'package:moments/features/interactions/presentation/view/comments/comments.dart';
import 'package:moments/features/interactions/presentation/view_model/interactions_bloc.dart';
import 'package:moments/features/posts/presentation/view/create_post/create_posts.dart';
import 'package:moments/features/posts/presentation/view_model/post_bloc.dart';
import 'package:moments/features/profile/view/user_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool hasFetchedPosts = false;

  @override
  void initState() {
    super.initState();
    if (!hasFetchedPosts) {
      context.read<PostBloc>().add(LoadPosts());
      hasFetchedPosts = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sharedPreferences = getIt<SharedPreferences>();
    final String? userId = sharedPreferences.getString("userID");

    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<PostBloc, PostState>(
            listenWhen: (previous, current) =>
                previous.isLoading != current.isLoading ||
                previous.posts != current.posts,
            listener: (context, state) {
              if (!state.isLoading && state.posts != null) {
                for (var post in state.posts!) {
                  context
                      .read<InteractionsBloc>()
                      .add(FetchComments(postId: post.id));
                  context
                      .read<InteractionsBloc>()
                      .add(GetPostLikes(postID: post.id));
                }
              }
            },
          ),
        ],
        child: BlocBuilder<PostBloc, PostState>(
          buildWhen: (previous, current) =>
              previous.isLoading != current.isLoading ||
              previous.posts != current.posts,
          builder: (context, postState) {
            if (postState.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (postState.posts == null || postState.posts!.isEmpty) {
              return const Center(child: Text("No posts available."));
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    // Create Post Section
                    Padding(
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
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                                color: Colors.grey[900]!, width: 0.4),
                          ),
                          padding: const EdgeInsets.all(12.0),
                          child: const Text(
                            'What\'s on your mind...?',
                            style: TextStyle(fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Posts Section
                    BlocBuilder<InteractionsBloc, InteractionsState>(
                      buildWhen: (previous, current) =>
                          previous.likes != current.likes ||
                          previous.commentsCount != current.commentsCount ||
                          previous.isLoading != current.isLoading,
                      builder: (context, interactionState) {
                        return Column(
                          children: postState.posts!.map((post) {
                            final likeData = interactionState.likes[post.id];
                            final likeCount = likeData?.likeCount ?? 0;
                            final userLiked = likeData?.userLiked ?? false;
                            final commentCount =
                                interactionState.commentsCount[post.id] ?? 0;

                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                children: [
                                  // Post Header
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) => UserScreen(
                                                  userId: post.user.id),
                                            ),
                                          );
                                        },
                                        child: CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(post.user.image[0]),
                                          radius: 22,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5,
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (_) => UserScreen(
                                                        userId: post.user.id),
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                Formatter.capitalize(
                                                    post.user.username),
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            Formatter.formatTimeAgo(
                                                post.createdAt),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w200),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),

                                  // Post Content
                                  if (post.content.isNotEmpty)
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        post.content,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  const SizedBox(height: 8),

                                  // Post Image with Carousel
                                  SizedBox(
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height *
                                        0.5,
                                    child: post.image.length > 1
                                        ? FlutterCarousel(
                                            options: FlutterCarouselOptions(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.5,
                                                autoPlay: false,
                                                showIndicator: true,
                                                viewportFraction: 1,
                                                slideIndicator:
                                                    CircularSlideIndicator(
                                                        slideIndicatorOptions:
                                                            SlideIndicatorOptions(
                                                  indicatorRadius: 4,
                                                  itemSpacing: 12,
                                                ))),
                                            items: post.image.map((imageUrl) {
                                              return SizedBox(
                                                width: double.infinity,
                                                child: Image.network(imageUrl,
                                                    fit: BoxFit.cover),
                                              );
                                            }).toList(),
                                          )
                                        : SizedBox(
                                            width: double.infinity,
                                            child: Image.network(post.image[0],
                                                fit: BoxFit.cover),
                                          ),
                                  ),
                                  const SizedBox(height: 8),

                                  // Like & Comment Buttons with Counts
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          context.read<InteractionsBloc>().add(
                                                ToggleLikes(
                                                    userID: userId!,
                                                    postID: post.id),
                                              );
                                        },
                                        icon: Icon(
                                          CupertinoIcons.heart_fill,
                                          color: userLiked
                                              ? Colors.red
                                              : Colors.grey,
                                        ),
                                      ),
                                      Text("$likeCount"),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        onPressed: () {
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (BuildContext
                                                commentBottomSheetContext) {
                                              return BlocProvider.value(
                                                value: context
                                                    .read<InteractionsBloc>(),
                                                child: CommentScreen(
                                                  postId: post.id,
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        icon: const Icon(
                                            CupertinoIcons.conversation_bubble),
                                      ),
                                      Text("$commentCount"),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
