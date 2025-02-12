import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:moments/core/utils/formatter.dart';
import 'package:moments/core/utils/time_ago_formatter.dart';
import 'package:moments/features/posts/presentation/view/create_post/create_posts.dart';
import 'package:moments/features/posts/presentation/view_model/post_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF63C57A), // Border color
                          width: 2, // Border width
                        ),
                      ),
                      child: const CircleAvatar(
                        radius: 10,
                        backgroundImage: NetworkImage(
                            'https://img.freepik.com/free-photo/artist-white_1368-3546.jpg'),
                      ),
                    ),
                    const SizedBox(width: 8),
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
                              useSafeArea: true,
                              isScrollControlled: true,
                              builder: (BuildContext bottomSheetContext) {
                                return BlocProvider.value(
                                  value: context.read<
                                      PostBloc>(), // Pass down the existing PostBloc
                                  child: CreatePostBottomSheet(),
                                );
                              },
                            );
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 1.0),
                            child: Text(
                              'What\'s on your mind?',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              BlocBuilder<PostBloc, PostState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    // Wrap CircularProgressIndicator in a Container with proper constraints
                    return Container(
                      height: MediaQuery.of(context).size.height *
                          .5, // Use screen height
                      width: double.infinity, // Full width
                      color: Colors
                          .white, // Optional: add a translucent background
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
                              // Post: User Image, Username, and Date
                              Row(
                                children: [
                                  Container(
                                    width: 45,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color(
                                            0xFF63C57A), // Border color
                                        width: 2, // Border width
                                      ),
                                    ),
                                    child: const CircleAvatar(
                                      radius: 10,
                                      backgroundImage: NetworkImage(
                                          'https://avatars.pfptown.com/156/anime-boy-pfp-4244.png'),
                                      //'https://avatars.pfptown.com/156/anime-boy-pfp-4244.png'
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        Formatter.capitalize(post
                                                .user.username ??
                                            'username'), // Replace with actual username
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        TimeAgoFormatter.format(post
                                            .createdAt), // Replace with actual date/time
                                        style: TextStyle(
                                            fontWeight: FontWeight.w200),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  post.content,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.left,
                                  //'This is the content of the post. Here you can add text, image, or whatever is necessary.'
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Post Image: Use Expanded for full available height
                              SizedBox(
                                width: double.infinity,
                                height: MediaQuery.of(context).size.height *
                                    0.5, // 50% of screen height
                                child: post.image.length > 1
                                    ? FlutterCarousel(
                                        options: FlutterCarouselOptions(
                                          height: MediaQuery.of(context).size.height *0.5,
                                          autoPlay:false, // Enable auto-scrolling
                                          autoPlayInterval: Duration(seconds: 3), // Interval between slides
                                          showIndicator: true,
                                          viewportFraction: 1.0, // Show page indicator
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
                                            image: NetworkImage(post.image[0]),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                              ),
                              const SizedBox(height: 8),

                              Row(
                                children: [
                                  // Like button with static like count
                                  IconButton(
                                    onPressed: () {
                                      print("Liked");
                                    },
                                    icon: const Icon(
                                      CupertinoIcons.heart_fill, // Heart icon
                                      color:
                                          Colors.red, // Red heart for 'liked'
                                    ),
                                  ),
                                  const Text(
                                    '120', // Static like count
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(width: 16),
                                  // Comment button with static comment count
                                  IconButton(
                                    onPressed: () {
                                      print("Commented");
                                    },
                                    icon: const Icon(
                                      CupertinoIcons
                                          .conversation_bubble, // Custom conversation bubble icon
                                      color: Colors.black, // Comment icon color
                                    ),
                                  ),
                                  const Text(
                                    '45', // Static comment count
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
      // Floating Action Button for creating a post
    );
  }
}
