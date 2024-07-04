import 'package:flutter/material.dart';
import 'package:pro_dictant/features/dictionary/presentation/pages/dictionary_page.dart';
import 'package:pro_dictant/features/profile/presentation/pages/profile_page.dart';
import 'package:pro_dictant/features/trainings/presentation/pages/trainings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: Image.asset(
              'assets/icons/profile.png',
              width: 35,
              height: 35,
              color: Color(0xFF243120),
            ),
            icon: Image.asset(
              'assets/icons/profile.png',
              width: 35,
              height: 35,
            ),
            label: 'Профиль',
          ),
          NavigationDestination(
            selectedIcon: Image.asset(
              'assets/icons/dictionary.png',
              width: 35,
              height: 35,
              color: Color(0xFF243120),
            ),
            icon: Image.asset(
              'assets/icons/dictionary.png',
              width: 35,
              height: 35,
            ),
            label: 'Словарь',
          ),
          NavigationDestination(
            selectedIcon: Image.asset(
              'assets/icons/trainings.png',
              width: 35,
              height: 35,
              color: Color(0xFF243120),
            ),
            icon: Image.asset(
              'assets/icons/trainings.png',
              width: 35,
              height: 35,
            ),
            label: 'Тренажёры',
          ),
        ],
      ),
      body: <Widget>[
        ProfilePage(),
        DictionaryPage(),
        TrainingsPage(),
      ][currentPageIndex],
    );
  }
}
