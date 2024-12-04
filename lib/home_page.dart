import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_dictant/features/profile/presentation/pages/profile_page.dart';
import 'package:pro_dictant/features/trainings/presentation/pages/trainings_page.dart';

import 'features/dictionary/presentation/pages/dictionary_page.dart';
import 'features/profile/presentation/manager/profile_bloc.dart';
import 'features/profile/presentation/manager/profile_state.dart';
import 'generated/l10n.dart';

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
              color: const Color(0xFF243120),
            ),
            icon: Image.asset(
              'assets/icons/profile.png',
              width: 35,
              height: 35,
            ),
            label: S.of(context).profile,
          ),
          NavigationDestination(
            selectedIcon: Image.asset(
              'assets/icons/dictionary.png',
              width: 35,
              height: 35,
              color: const Color(0xFF243120),
            ),
            icon: Image.asset(
              'assets/icons/dictionary.png',
              width: 35,
              height: 35,
            ),
            label: S.of(context).dictionary,
          ),
          NavigationDestination(
            selectedIcon: Image.asset(
              'assets/icons/trainings.png',
              width: 35,
              height: 35,
              color: const Color(0xFF243120),
            ),
            icon: Image.asset(
              'assets/icons/trainings.png',
              width: 35,
              height: 35,
            ),
            label: S.of(context).trainings,
          ),
        ],
      ),
      body: <Widget>[
        const ProfilePage(),
        const DictionaryPage(),
        BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
          if (state is ProfileLoading) {
            return _loadingIndicator();
          } else if (state is ProfileLoaded) {
            return TrainingsPage(
              goal: state.statistics.goal,
              isTodayCompleted: state.statistics.isTodayCompleted,
            );
          } else {
            return const SizedBox();
          }
        }),
      ][currentPageIndex],
    );
  }

  Widget _loadingIndicator() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
