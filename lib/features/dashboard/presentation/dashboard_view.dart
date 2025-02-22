import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      child: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          final cubit = context.read<DashboardCubit>();

          return Scaffold(
            appBar: state.selectedIndex == 1
                ? null
                : AppBar(
                    actions: state.selectedIndex == 0
                        ? [
                            IconButton(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              icon: const Icon(Icons.notifications_none,
                                  color: Colors.black),
                              onPressed: () {
                                context.read<InteractionsBloc>().add(UpdateNotifications());  
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (BuildContext
                                      notificationBottomSheetContext) {
                                    return BlocProvider.value(
                                        value: context.read<InteractionsBloc>(),
                                        child: NotificationScreen());
                                  },
                                );
                              },
                            ),
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
                                          value:
                                              context.read<ConversationBloc>(),
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
                            builder: (context, state) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Text(
                                  Formatter.capitalize(state.user?.username ??
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
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(Icons.camera_outlined), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.search), label: 'Search'),
                BottomNavigationBarItem(
                  icon: Icon(IconData(0xf3fb,
                      fontFamily: 'CupertinoIcons',
                      fontPackage: 'cupertino_icons')),
                  label: "Chat",
                ),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Me'),
              ],
            ),
          );
        },
      ),
    );
  }
}
