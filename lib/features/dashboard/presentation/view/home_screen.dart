import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:moments/core/utils/formatter.dart';
import 'package:moments/features/posts/presentation/view/create_post/create_posts.dart';
import 'package:moments/features/posts/presentation/view_model/post_bloc.dart';
import 'package:moments/features/profile/view_model/profile_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Container(
                      //   width: 45,
                      //   height: 45,
                      //   decoration: BoxDecoration(
                      //     shape: BoxShape.circle,
                      //     border: Border.all(
                      //       color: const Color(0xFF63C57A),
                      //       width: 2,
                      //     ),
                      //   ),
                      //   child: const CircleAvatar(
                      //     radius: 10,
                      //     backgroundImage: NetworkImage(
                      //         'https://img.freepik.com/free-photo/artist-white_1368-3546.jpg'),
                      //   ),
                      // ),

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
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 1.0),
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
                SizedBox(
                  height: 10,
                ),
                // ✅ Posts Section
                BlocBuilder<PostBloc, PostState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return Container(
                        height: MediaQuery.of(context).size.height * .5,
                        width: double.infinity,
                        color: Colors.white,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (state.posts == null || state.posts!.isEmpty) {
                      return const Center(
                          child: Text("No posts as of currently."));
                    } else {
                      return Column(
                        children: state.posts!.map((post) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              children: [
                                // Post Header (User Info)
                                Row(
                                  children: [
                                    Container(
                                      width: 45,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: const Color(0xFF63C57A),
                                          width: 2,
                                        ),
                                      ),
                                      child: CircleAvatar(
                                        radius: 10,
                                        backgroundImage:
                                            NetworkImage(post.user.image[0]),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          Formatter.capitalize(
                                              post.user.username ?? 'username'),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          Formatter.formatTimeAgo(
                                              post.createdAt),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w200),
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
                                      style: TextStyle(fontSize: 16),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                const SizedBox(height: 8),

                                // Post Image
                                SizedBox(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  child: post.image.length > 1
                                      ? FlutterCarousel(
                                          options: FlutterCarouselOptions(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.5,
                                            autoPlay: false,
                                            showIndicator: true,
                                            viewportFraction: 1.0,
                                            slideIndicator:
                                                CircularSlideIndicator(
                                              slideIndicatorOptions:
                                                  SlideIndicatorOptions(
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
                                              image:
                                                  NetworkImage(post.image[0]),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                ),
                                const SizedBox(height: 8),

                                // Like & Comment Buttons
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        print("Liked");
                                      },
                                      icon: const Icon(
                                        CupertinoIcons.heart_fill,
                                        color: Colors.red,
                                      ),
                                    ),
                                    const Text(
                                      '120',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
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
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
