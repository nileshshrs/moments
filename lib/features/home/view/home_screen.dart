import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Color textColor = Colors.white;
  final Color bgColor = Color(0xFF121212);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 1,
        title: SizedBox(
          height: 80,
          width: 140,
          child: Image.asset(
            "assets/images/logo-dark.png",
            fit: BoxFit.cover,
          ),
        ),
        bottom: PreferredSize(
          preferredSize:
              Size(double.infinity, 2), // Height of the bottom border
          child: Container(
            color: Colors.white, // The color of the bottom border
            height: .1, // Height of the border
          ),
        ),
      ),
      body: SafeArea(
          child: Center(
        child: Text(
          "home screen",
          style: TextStyle(color: Colors.white),
        ),
      )),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 2,
        type: BottomNavigationBarType.fixed,
        backgroundColor: bgColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
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
            icon: Icon(Icons.add_box_outlined),
            label: 'Create',
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
