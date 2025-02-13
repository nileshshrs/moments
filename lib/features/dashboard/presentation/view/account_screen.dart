import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moments/core/utils/formatter.dart';
import 'package:moments/features/posts/presentation/view_model/post_bloc.dart';
import 'package:moments/features/profile/view/edit_profile.dart';
import 'package:moments/features/profile/view_model/profile_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  final int followersCount = 10;
  final int followingCount = 10;

  @override
  Widget build(BuildContext context) {
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
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return Column(
                children: [
                  // Profile Section
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: state.user?.image != null &&
                                      state.user!.image!.isNotEmpty
                                  ? NetworkImage(state.user!.image![0])
                                  : const NetworkImage(
                                      'https://img.freepik.com/free-photo/artist-white_1368-3546.jpg'),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 35),
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        Formatter.capitalize(
                                            (state.user!.fullname == null ||
                                                    state.user!.fullname!
                                                        .isEmpty)
                                                ? state.user!.username
                                                : state.user!.fullname!),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const SizedBox(width: 10),
                                        Column(
                                          children: [
                                            Text(
                                              state.posts!.length.toString(),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            const Text(
                                              'posts',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          children: [
                                            Text(
                                              '$followersCount',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            const Text(
                                              'followers',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          children: [
                                            Text(
                                              '$followingCount',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            const Text(
                                              'following',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            Formatter.capitalize(
                                state.user?.email ?? 'example@example.com'),
                            textAlign: TextAlign.start,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(height: 5),
                        if (state.user?.bio != null &&
                            state.user!.bio!.isNotEmpty)
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              state.user!
                                  .bio!, // ✅ Safely using bio after checking it's not null
                              textAlign: TextAlign.start,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w400),
                            ),
                          ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 38,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                              elevation: 0,
                              disabledForegroundColor: Colors.grey[200],
                              disabledBackgroundColor: Colors.grey[200],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              shadowColor: Colors.transparent,
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
                              "Edit profile",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Grid Icon Section with Border below it
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
                              Icon(
                                Icons.grid_on,
                                size: 30,
                              ),
                              const SizedBox(height: 4),
                              Container(
                                height: 3.0,
                                color: Colors.black,
                                width: 30,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Post Section (Grid of images)
                  state.posts == null || state.posts!.isEmpty
                      ? Container(
                          height: MediaQuery.of(context).size.height * .5,
                          padding: const EdgeInsets.all(16.0),
                          child: const Center(
                            child: Text(
                              "Capture your very first moment",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
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
                                print(post);
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(0),
                                child: Image.network(
                                  (post.image.isNotEmpty)
                                      ? post.image[0]
                                      : 'https://images.pexels.com/photos/20189671/pexels-photo-20189671/free-photo-of-flowers-around-logo-board-near-building-wall.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
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
