import 'package:flutter/material.dart';

import '../../live_radio/presentation/live_radio_screen.dart';
import '../../news/presentation/news_screen.dart';
import '../../profile/presentation/profile_screen.dart';
import '../../schedule/presentation/schedule_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  var _index = 0;

  static const _screens = [
    LiveRadioScreen(),
    ScheduleScreen(),
    NewsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    body: IndexedStack(index: _index, children: _screens),
    bottomNavigationBar: NavigationBar(
      selectedIndex: _index,
      onDestinationSelected: (index) => setState(() => _index = index),
      destinations: const [
        NavigationDestination(
          key: Key('nav-home'),
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Início',
        ),
        NavigationDestination(
          key: Key('nav-schedule'),
          icon: Icon(Icons.calendar_month_outlined),
          selectedIcon: Icon(Icons.calendar_month),
          label: 'Programação',
        ),
        NavigationDestination(
          key: Key('nav-news'),
          icon: Icon(Icons.newspaper_outlined),
          selectedIcon: Icon(Icons.newspaper),
          label: 'Notícias',
        ),
        NavigationDestination(
          key: Key('nav-profile'),
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Você',
        ),
      ],
    ),
  );
}
