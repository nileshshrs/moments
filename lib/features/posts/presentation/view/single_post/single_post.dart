import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:moments/app/di/di.dart';
import 'package:moments/features/posts/presentation/view_model/post_bloc.dart';

class SinglePostScreen extends StatelessWidget {
  final String postId;

  const SinglePostScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PostBloc>()..add(LoadPostByID(id: postId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Post"),
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              size: 20,
            ),
          ),
        ),
        body: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              final post = state.post;

              if (post == null) {
                return const Center(child: Text("Failed to load post"));
              }

              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          child: const CircleAvatar(
                            radius: 10,
                            backgroundImage: NetworkImage(
                              'https://img.freepik.com/free-vector/young-girl-anime-character-poster_603843-2522.jpg?ga=GA1.1.875532354.1739759428&semt=ais_hybrid',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "John Doe",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 2),
                            Text(
                              "2 hours ago",
                              style: TextStyle(fontWeight: FontWeight.w200),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Post Content
                    const SizedBox(
                      width: double.infinity,
                      child: Text(
                        "This is a static post content for demonstration purposes.",
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Post Image Handling
                    if (post.image.isNotEmpty == true)
                      SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: (post.image.length) > 1
                            ? FlutterCarousel(
                                options: FlutterCarouselOptions(
                                  height:
                                      MediaQuery.of(context).size.height * 0.6,
                                  autoPlay: false,
                                  showIndicator: true,
                                  viewportFraction: 1.0,
                                  slideIndicator: CircularSlideIndicator(
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
                              fontSize: 16, fontWeight: FontWeight.w500),
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
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
