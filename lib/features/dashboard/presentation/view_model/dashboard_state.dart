
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:moments/features/dashboard/presentation/view/account_screen.dart';
import 'package:moments/features/dashboard/presentation/view/chat_screen.dart';
import 'package:moments/features/dashboard/presentation/view/home_screen.dart';
import 'package:moments/features/dashboard/presentation/view/search_screen.dart';

class DashboardState extends Equatable {
  final int selectedIndex;
  final List<Widget> views;

  const DashboardState({
    required this.selectedIndex,
    required this.views,
  });

  static DashboardState initial() {
    return DashboardState(
      selectedIndex: 0,
      views: [
        // MultiBlocProvider(
        //   providers: [
        //     BlocProvider.value(value: getIt<PostBloc>()),
        //   ],
        //   child: HomeScreen(),
        // ),
        HomeScreen(),
        SearchScreen(),
        ChatScreen(),
        ProfileScreen(),
      ],
    );
  }

  // Add `copyWith` method for immutability
  DashboardState copyWith({
    int? selectedIndex,
    List<Widget>? views,
  }) {
    return DashboardState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      views: views ?? this.views,
    );
  }

  @override
  List<Object?> get props => [selectedIndex, views];
}