import 'package:flutter/material.dart';
import 'package:moments/features/view/bottom_navigation/account_screen.dart';
import 'package:moments/features/view/bottom_navigation/chat_screen.dart';
import 'package:moments/features/view/bottom_navigation/home_screen.dart';
import 'package:moments/features/view/bottom_navigation/search_screen.dart';

class BottomNavigationView extends StatefulWidget {
  const BottomNavigationView({super.key});

  @override
  State<BottomNavigationView> createState() => _BottomNavigationViewState();
}

class _BottomNavigationViewState extends State<BottomNavigationView> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const HomeScreen(),
    const SearchScreen(),
    const ChatScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: .5,
        title: SizedBox(
          height: 80,
          width: 140,
          child: Image.asset(
            "assets/images/logo-light.png",
            fit: BoxFit.cover,
          ),
        ),
      ),
      body: SafeArea(
        child: _screens[_currentIndex], // Display the selected screen
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (value) => setState(() {
          _currentIndex = value;
        }),
        elevation: 1,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(IconData(0xf3fb,
                fontFamily: 'CupertinoIcons', fontPackage: 'cupertino_icons')),
            label: "Chat",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: 'Me',
          ),
        ],
      ),
    );
  }
}
