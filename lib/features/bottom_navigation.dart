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
      appBar: _currentIndex == 1
          ? null
          : AppBar(
              actions: _currentIndex == 0
                  ? [
                      IconButton(
                        icon: const Icon(
                          Icons.add_circle,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          print("Add button pressed");
                        },
                      ),
                    ]
                  : _currentIndex == 2
                      ? [
                          IconButton(
                            icon: const Icon(
                              Icons.edit_square,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              print("Create message button pressed");
                            },
                          ),
                        ]
                      : null,
              automaticallyImplyLeading: false,
              elevation: .2,
              title: _currentIndex == 0
                  ? SizedBox(
                      height: 80,
                      width: 140,
                      child: Image.asset(
                        "assets/images/logo-light.png",
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        "Example User",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
            ),
      body: SafeArea(
        child: _screens[_currentIndex],
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
