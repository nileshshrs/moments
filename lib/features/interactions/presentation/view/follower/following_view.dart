import 'package:flutter/material.dart';
import 'package:moments/features/interactions/data/dto/follow_dto.dart';
import 'package:moments/features/profile/view/user_screen.dart';

class FollowingBottomSheet extends StatelessWidget {
  final List<FollowDTO> following;

  const FollowingBottomSheet({super.key, this.following = const []});

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
                      "Following",
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
            SizedBox(
              height: 20,
            ),
            // Following List
            Expanded(
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: searchController,
                builder: (context, value, child) {
                  final filteredList = value.text.isEmpty
                      ? following
                      : following
                          .where((user) => user.following.username
                              .toLowerCase()
                              .contains(value.text.toLowerCase()))
                          .toList();

                  if (following.isEmpty) {
                    return const Center(
                      child: Text(
                        'No users followed',
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
                      final user = filteredList[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(user.following.image[0]),
                        ),
                        title: Text(user.following.username),
                        subtitle: Text(user.following.email),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  UserScreen(userId: user.following.id!),
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
