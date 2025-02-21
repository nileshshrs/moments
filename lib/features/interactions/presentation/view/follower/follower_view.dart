import 'package:flutter/material.dart';
import 'package:moments/features/interactions/data/dto/follow_dto.dart';
import 'package:moments/features/profile/view/user_screen.dart';

class FollowerBottomSheet extends StatelessWidget {
  final List<FollowDTO> followers;

  const FollowerBottomSheet({super.key, this.followers = const []});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    return Material(
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          children: [
            // Header Row
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 20,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 40),
                    child: Text(
                      "Followers",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: SizedBox(
                height: 40,
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by Username',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: ValueListenableBuilder<TextEditingValue>(
                      valueListenable: searchController,
                      builder: (context, value, child) {
                        return value.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () => searchController.clear(),
                              )
                            : const SizedBox.shrink();
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            // Followers List
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: searchController,
                builder: (context, value, child) {
                  final filteredList = value.text.isEmpty
                      ? followers
                      : followers
                          .where((follower) => follower.follower.username
                              .toLowerCase()
                              .contains(value.text.toLowerCase()))
                          .toList();

                  if (followers.isEmpty) {
                    return const Center(
                      child: Text(
                        'No followers available',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final follower = filteredList[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(follower.follower.image[0]),
                        ),
                        title: Text(follower.follower.username),
                        subtitle: Text(follower.follower.email),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  UserScreen(userId: follower.follower.id!),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
