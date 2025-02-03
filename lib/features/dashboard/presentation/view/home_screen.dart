import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moments/app/di/di.dart';
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
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return BlocProvider<PostBloc>(
                                  create: (_) => getIt<
                                      PostBloc>(), // Provide PostBloc here
                                  child:
                                      CreatePostBottomSheet(), // Use the widget here
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
                    return const Center(child: CircularProgressIndicator());
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
                                        post.user.username ??
                                            'username', // Replace with actual username
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
                              Container(
                                width: double.infinity,
                                height: MediaQuery.of(context).size.height *
                                    0.5, // 50% of screen height
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      'https://images.pexels.com/photos/20189671/pexels-photo-20189671/free-photo-of-flowers-around-logo-board-near-building-wall.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2', // Example image URL
                                    ),
                                    fit: BoxFit.cover,
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
