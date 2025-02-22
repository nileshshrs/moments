import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moments/features/interactions/presentation/view_model/interactions_bloc.dart';
import 'package:moments/features/profile/view/user_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    // Force refresh notifications when entering the screen
    context.read<InteractionsBloc>().add(GetAllNotifications());
  }

  String getNotificationMessage(String type) {
    switch (type) {
      case 'follow':
        return "has started to follow you";
      case 'like':
        return "liked your post";
      case 'comment':
        return "commented on your post";
      default:
        return "sent you a notification";
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      "Notifications",
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
            const SizedBox(height: 20),
            // Notifications List with BlocBuilder
            Expanded(
              child: BlocBuilder<InteractionsBloc, InteractionsState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ListView.builder(
                    itemCount: state.notifications!.length,
                    itemBuilder: (context, index) {
                      final notification = state.notifications![index];

                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            notification.sender.image[0],
                          ),
                          radius: 25, // Ensures consistent size
                        ),
                        title: Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Text(
                                    notification.sender.username,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      getNotificationMessage(notification.type),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (notification.type == "like" &&
                                notification.post?.image != null &&
                                notification.post!.image!.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  notification.post!.image![0],
                                  height: 50, // Same height as avatar
                                  width: 50, // Square aspect ratio
                                  fit: BoxFit.cover,
                                ),
                              ),
                          ],
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => UserScreen(
                                userId: notification.sender.username,
                              ),
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
