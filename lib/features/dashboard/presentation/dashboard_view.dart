import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:moments/app/di/di.dart';
import 'package:moments/core/utils/formatter.dart';
import 'package:moments/features/conversation/presentation/view/create_conversation.dart';
import 'package:moments/features/conversation/presentation/view_model/conversation_bloc.dart';
import 'package:moments/features/dashboard/presentation/view_model/dashboard_cubit.dart';
import 'package:moments/features/dashboard/presentation/view_model/dashboard_state.dart';
import 'package:moments/features/interactions/presentation/view/notifications/notification_view.dart';
import 'package:moments/features/interactions/presentation/view_model/interactions_bloc.dart';
import 'package:moments/features/posts/presentation/view/create_post/create_posts.dart';
import 'package:moments/features/posts/presentation/view_model/post_bloc.dart';
import 'package:moments/features/profile/view_model/profile_bloc.dart';
import 'package:moments/features/search/view_model/search_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A widget that listens to gyroscope sensor events.
/// When a tilt is detected on the y-axis (if its absolute value exceeds 1),
/// it prints the current DashboardState and a custom message.
class GyroscopeListener extends StatefulWidget {
  final Widget child;
  const GyroscopeListener({Key? key, required this.child}) : super(key: key);

  @override
  _GyroscopeListenerState createState() => _GyroscopeListenerState();
}

class _GyroscopeListenerState extends State<GyroscopeListener> {
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;
  bool _subscriptionInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize subscription only once when dependencies are available.
    if (!_subscriptionInitialized) {
      _subscriptionInitialized = true;
      _gyroscopeSubscription = gyroscopeEvents.listen((GyroscopeEvent event) {
        // Only trigger on y-axis events
        final dashboardCubit = context.read<DashboardCubit>();
        final currentIndex = dashboardCubit.state.selectedIndex;
        final maxIndex = dashboardCubit.state.views.length - 1;

        if (event.y > 1) {
          // Increase index only if not at the maximum index.
          if (currentIndex < maxIndex) {
            final newIndex = currentIndex + 1;
            dashboardCubit.onTabTapped(newIndex);
            print("Incremented selected index: $newIndex");
          } else {
            print("Already at maximum index: $currentIndex. No increment.");
          }
        } else if (event.y < -1) {
          // Decrease index only if not at the minimum index.
          if (currentIndex > 0) {
            final newIndex = currentIndex - 1;
            dashboardCubit.onTabTapped(newIndex);
            print("Decremented selected index: $newIndex");
          } else {
            print("Already at minimum index: $currentIndex. No decrement.");
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _gyroscopeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<DashboardCubit>()),
        BlocProvider.value(value: getIt<PostBloc>()),
        BlocProvider.value(value: getIt<SearchBloc>()),
        BlocProvider.value(value: getIt<ProfileBloc>()),
        BlocProvider.value(value: getIt<ConversationBloc>()),
        BlocProvider.value(value: getIt<InteractionsBloc>()),
      ],
      // Place GyroscopeListener here so that it can access DashboardCubit.
      child: GyroscopeListener(
        child: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            final cubit = context.read<DashboardCubit>();
            final sharedPreferences = getIt<SharedPreferences>();
            final userID = sharedPreferences.getString('userID') ?? "";

            return Scaffold(
              appBar: state.selectedIndex == 1
                  ? null
                  : AppBar(
                      actions: state.selectedIndex == 0
                          ? [
                              // Notification Icon with Badge
                              Stack(
                                children: [
                                  IconButton(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    icon: const Icon(
                                        Icons.notifications_rounded,
                                        color: Colors.black),
                                    onPressed: () {
                                      context
                                          .read<InteractionsBloc>()
                                          .add(UpdateNotifications());
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (BuildContext
                                            notificationBottomSheetContext) {
                                          return BlocProvider.value(
                                            value: context
                                                .read<InteractionsBloc>(),
                                            child: NotificationScreen(),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  BlocBuilder<InteractionsBloc,
                                      InteractionsState>(
                                    builder: (context, notificationState) {
                                      final hasUnreadNotifications =
                                          notificationState.notifications
                                                  ?.any((n) => !n.read) ??
                                              false;
                                      print(
                                          "Unread Notifications: $hasUnreadNotifications");
                                      return hasUnreadNotifications
                                          ? const Positioned(
                                              right: 12,
                                              top: 11,
                                              child: CircleAvatar(
                                                radius: 5,
                                                backgroundColor: Colors.red,
                                              ),
                                            )
                                          : const SizedBox();
                                    },
                                  ),
                                ],
                              ),
                              // Add Post Icon
                              IconButton(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                icon: const Icon(Icons.add_circle,
                                    color: Colors.black),
                                onPressed: () {
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
                              ),
                            ]
                          : state.selectedIndex == 2
                              ? [
                                  IconButton(
                                    icon: const Icon(Icons.edit_square,
                                        color: Colors.black),
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (BuildContext
                                            conversationBottomSheetContext) {
                                          return BlocProvider.value(
                                            value: context
                                                .read<ConversationBloc>(),
                                            child: CreateConversation(),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ]
                              : null,
                      automaticallyImplyLeading: false,
                      elevation: .2,
                      title: state.selectedIndex == 0
                          ? SizedBox(
                              height: 80,
                              width: 140,
                              child: Image.asset(
                                "assets/images/logo-light.png",
                                fit: BoxFit.cover,
                              ),
                            )
                          : BlocBuilder<ProfileBloc, ProfileState>(
                              builder: (context, profileState) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: Text(
                                    Formatter.capitalize(
                                        profileState.user?.username ??
                                            'Example Username'),
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                );
                              },
                            ),
                    ),
              body: SafeArea(child: state.views[state.selectedIndex]),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: state.selectedIndex,
                onTap: cubit.onTabTapped,
                elevation: 1,
                type: BottomNavigationBarType.fixed,
                items: <BottomNavigationBarItem>[
                  const BottomNavigationBarItem(
                      icon: Icon(Icons.camera_outlined), label: 'Home'),
                  const BottomNavigationBarItem(
                      icon: Icon(Icons.search), label: 'Search'),
                  // Chat Icon with Badge
                  BottomNavigationBarItem(
                    icon: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(IconData(0xf3fb,
                            fontFamily: 'CupertinoIcons',
                            fontPackage: 'cupertino_icons')),
                        BlocBuilder<ConversationBloc, ConversationState>(
                          builder: (context, conversationState) {
                            final unreadCount = conversationState.conversation
                                    ?.where((c) => c.read == userID)
                                    .length ??
                                0;
                            return unreadCount > 0
                                ? Positioned(
                                    left: 15,
                                    bottom: 8,
                                    child: CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.red,
                                      child: Text(
                                        unreadCount > 9
                                            ? "9+"
                                            : unreadCount.toString(),
                                        style: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )
                                : const SizedBox();
                          },
                        ),
                      ],
                    ),
                    label: "Chat",
                  ),
                  // Profile Icon
                  const BottomNavigationBarItem(
                      icon: Icon(Icons.person), label: 'Me'),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
