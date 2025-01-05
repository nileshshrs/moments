import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moments/features/home/presentation/view_model/home_cubit.dart';
import 'package:moments/features/home/presentation/view_model/home_state.dart';

class BottomNavigationView extends StatelessWidget {
  const BottomNavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final cubit = context.read<HomeCubit>();

          return Scaffold(
            appBar: state.selectedIndex == 1
                ? null
                : AppBar(
                    actions: state.selectedIndex == 0
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
                        : state.selectedIndex == 2
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
                    title: state.selectedIndex == 0
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
              child: state.views[state.selectedIndex],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: state.selectedIndex,
              onTap: cubit.onTabTapped,
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
                      fontFamily: 'CupertinoIcons',
                      fontPackage: 'cupertino_icons')),
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
        },
      ),
    );
  }
}
