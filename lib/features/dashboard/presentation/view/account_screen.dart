import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:moments/core/utils/formatter.dart';
import 'package:moments/features/interactions/presentation/view/follow/follower_view.dart';
import 'package:moments/features/interactions/presentation/view/follow/following_view.dart';
import 'package:moments/features/interactions/presentation/view_model/interactions_bloc.dart';
import 'package:moments/features/posts/presentation/view/single_post/single_post.dart';
import 'package:moments/features/posts/presentation/view_model/post_bloc.dart';
import 'package:moments/features/profile/view/edit_profile.dart';
import 'package:moments/features/profile/view_model/profile_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch userID from SharedPreferences using GetIt
    final prefs = GetIt.I<SharedPreferences>();
    final userID = prefs.getString('userID');

    context.read<InteractionsBloc>().add(FetchFollowers(id: userID!));
    context.read<InteractionsBloc>().add(FetchFollowings(id: userID));

    return MultiBlocListener(
      listeners: [
        BlocListener<ProfileBloc, ProfileState>(
          listenWhen: (previous, current) =>
              previous.isSuccess != current.isSuccess && current.isSuccess,
          listener: (context, state) {
            context.read<PostBloc>().add(LoadPosts());
          },
        ),
      ],
      child: SingleChildScrollView(
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state.isLoading) {
              return Container(
                height: MediaQuery.of(context).size.height * .5,
                width: double.infinity,
                color: Colors.white,
                child: const Center(child: CircularProgressIndicator()),
              );
            } else {
              return Column(
                children: [
                  // Profile Header Section
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: state.user?.image != null &&
                                  state.user!.image!.isNotEmpty
                              ? NetworkImage(state.user!.image![0])
                              : const NetworkImage(
                                  'https://img.freepik.com/free-photo/artist-white_1368-3546.jpg'),
                        ),
                        const SizedBox(width: 30),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Formatter.capitalize(
                                    (state.user!.fullname == null ||
                                            state.user!.fullname!.isEmpty)
                                        ? state.user!.username
                                        : state.user!.fullname!),
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        state.posts?.length.toString() ?? "0",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Text('Posts',
                                          style: TextStyle(fontSize: 14)),
                                    ],
                                  ),
                                  const SizedBox(width: 51),
                                  BlocBuilder<InteractionsBloc,
                                      InteractionsState>(
                                    builder: (context, interactionState) {
                                      return Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                builder: (BuildContext
                                                    followerBottomSheetContext) {
                                                  return BlocProvider.value(
                                                      value: context.read<
                                                          InteractionsBloc>(),
                                                      child: FollowerBottomSheet(
                                                          followers:
                                                              interactionState
                                                                  .followers!));
                                                },
                                              );
                                            },
                                            child: Text(
                                              '${interactionState.followers?.length ?? 0}',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          const Text('Followers',
                                              style: TextStyle(fontSize: 14)),
                                        ],
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 51),
                                  BlocBuilder<InteractionsBloc,
                                      InteractionsState>(
                                    builder: (context, interactionState) {
                                      return Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                builder: (BuildContext
                                                    followingBottomSheetContext) {
                                                  return BlocProvider.value(
                                                      value: context.read<
                                                          InteractionsBloc>(),
                                                      child: FollowingBottomSheet(
                                                          following:
                                                              interactionState
                                                                  .followings!));
                                                },
                                              );
                                            },
                                            child: Text(
                                              '${interactionState.followings?.length ?? 0}',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          const Text('Following',
                                              style: TextStyle(fontSize: 14)),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Edit Profile Button
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
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext editProfileBottomSheet) {
                              return BlocProvider.value(
                                value: context.read<ProfileBloc>(),
                                child: EditProfile(state.user!),
                              );
                            },
                          );
                        },
                        child: const Text(
                          "Edit Profile",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Grid Icon Section
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

                  // Posts Section
                  state.posts == null || state.posts!.isEmpty
                      ? Container(
                          height: MediaQuery.of(context).size.height * .5,
                          padding: const EdgeInsets.all(16.0),
                          child: const Center(
                            child: Text(
                              "Capture your very first moment",
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
                          itemCount: state.posts!.length,
                          itemBuilder: (context, index) {
                            final post = state.posts![index];

                            return GestureDetector(
                              onTap: () {
                                if (post.id != null) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => MultiBlocProvider(
                                        providers: [
                                          BlocProvider.value(
                                              value: context.read<PostBloc>()),
                                          BlocProvider.value(
                                              value: context
                                                  .read<InteractionsBloc>()),
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
              );
            }
          },
        ),
      ),
    );
  }
}
