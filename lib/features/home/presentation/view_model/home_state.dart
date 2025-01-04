import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:moments/features/view/bottom_navigation/account_screen.dart';
import 'package:moments/features/view/bottom_navigation/chat_screen.dart';
import 'package:moments/features/view/bottom_navigation/home_screen.dart';
import 'package:moments/features/view/bottom_navigation/search_screen.dart';

class HomeState extends Equatable {
  final int selectedIndex;
  final List<Widget> views;

  const HomeState({
    required this.selectedIndex,
    required this.views,
  });

  static HomeState initial() {
    return const HomeState(
      selectedIndex: 0,
      views: [
        HomeScreen(),
        SearchScreen(),
        ChatScreen(),
        ProfileScreen(),
      ],
    );
  }

  // Add `copyWith` method for immutability
  HomeState copyWith({
    int? selectedIndex,
    List<Widget>? views,
  }) {
    return HomeState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      views: views ?? this.views,
    );
  }

  @override
  List<Object?> get props => [selectedIndex, views];
}
