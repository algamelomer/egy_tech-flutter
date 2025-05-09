import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/providers/theme_provider.dart';
import 'package:my_app/screens/Following.dart';
import 'package:my_app/screens/MyProfile.dart';
import 'package:my_app/screens/studio_screen.dart';

import 'package:my_app/widgets/nav&footer/custom_appbar.dart';
import './screens/home.dart';
import './screens/collaborate_screen.dart';
import 'widgets/nav&footer/custom_bottom_nav.dart';

class MainScreen extends ConsumerStatefulWidget {
  final int index;
  const MainScreen({super.key, required this.index});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  late int _selectedIndex;
  late int _lastMainTabIndex;

  final List<Widget> _pages = [

    const HomeScreen(),
    const Placeholder(),
    const StudioScreen(),
    const CollaborateScreen(),
    const MyProfile(),
    const Following(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.index;
    _lastMainTabIndex = widget.index.clamp(0, 3);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index >= 0 && index <= 3) {
        _lastMainTabIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch themeProvider to ensure rebuild on theme changes
    ref.watch(themeProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: _pages[_selectedIndex],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _lastMainTabIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}