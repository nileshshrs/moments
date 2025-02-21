import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moments/app/di/di.dart';
import 'package:moments/core/utils/formatter.dart';
import 'package:moments/features/interactions/presentation/view_model/interactions_bloc.dart';
import 'package:moments/features/posts/presentation/view/single_post/single_post.dart';
import 'package:moments/features/posts/presentation/view_model/post_bloc.dart';
import 'package:moments/features/profile/view_model/profile_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserScreen extends StatelessWidget {
  final String userId;

  const UserScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final profileBloc = getIt<ProfileBloc>();
    final interactionsBloc = getIt<InteractionsBloc>();
    final sharedPrefs = getIt<SharedPreferences>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileBloc.add(LoadProfileByID(id: userId));
      interactionsBloc.add(FetchFollowers(id: userId));
      interactionsBloc.add(FetchFollowings(id: userId));
    });

    final String? currentUserID = sharedPrefs.getString('userID');
    final bool isCurrentUser = userId == currentUserID;

    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<ProfileBloc, ProfileState>(
          bloc: profileBloc,
          builder: (context, state) {
            return Text(
              state.userByID != null
                  ? Formatter.capitalize(state.userByID!.username)
                  : "Loading...",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            );
          },
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        ),
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        bloc: profileBloc,
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.userByID == null) {
            return const Center(child: Text("User not found"));
          }

          final user = state.userByID!;
          final posts = state.postsByUserID ?? [];

          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(
                            user.image != null && user.image!.isNotEmpty
                                ? user.image!.first
                                : 'https://img.freepik.com/free-photo/artist-white_1368-3546.jpg',
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Formatter.capitalize(
                                    user.fullname ?? user.username),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 10),
                              BlocBuilder<InteractionsBloc, InteractionsState>(
                                bloc: interactionsBloc,
                                builder: (context, interactionState) {
                                  final followerCount =
                                      interactionState.followers!.length;
                                  final followingCount =
                                      interactionState.followings!.length;
                                  return Row(
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            posts.length.toString(),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Text('Posts',
                                              style: TextStyle(fontSize: 14)),
                                        ],
                                      ),
                                      const SizedBox(width: 51),
                                      Column(
                                        children: [
                                          Text(
                                            followerCount.toString(),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Text('Followers',
                                              style: TextStyle(fontSize: 14)),
                                        ],
                                      ),
                                      const SizedBox(width: 51),
                                      Column(
                                        children: [
                                          Text(
                                            followingCount.toString(),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Text('Following',
                                              style: TextStyle(fontSize: 14)),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (isCurrentUser)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                        height: 38,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[200],
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onPressed: () {},
                          child: const Text(
                            "Edit profile",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                        height: 38,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onPressed: () {
                            // TODO: Implement follow logic
                          },
                          child: const Text(
                            "Follow",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade400,
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              const Icon(Icons.grid_on, size: 30),
                              const SizedBox(height: 4),
                              Container(
                                  height: 3.0, color: Colors.black, width: 30),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  posts.isEmpty
                      ? Container(
                          height: MediaQuery.of(context).size.height * .5,
                          padding: const EdgeInsets.all(16.0),
                          child: const Center(
                            child: Text(
                              "No posts yet",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 4,
                          ),
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            final post = posts[index];

                            return GestureDetector(
                              onTap: () {
                                if (post.id != null) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => MultiBlocProvider(
                                        providers: [
                                          BlocProvider.value(
                                              value: getIt<PostBloc>()),
                                          BlocProvider.value(
                                              value: getIt<InteractionsBloc>()),
                                        ],
                                        child:
                                            SinglePostScreen(postId: post.id!),
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(0),
                                child: Image.network(
                                  post.image.isNotEmpty
                                      ? post.image[0]
                                      : 'https://via.placeholder.com/150',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
