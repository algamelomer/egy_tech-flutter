import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/main_screen.dart';
import 'package:my_app/providers/theme_provider.dart';
import 'package:my_app/screens/Following.dart';
import 'package:my_app/screens/home.dart';
import 'package:my_app/screens/profileSettings.dart';
import 'package:my_app/screens/store_details_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_app/screens/login_screen.dart';
import 'package:my_app/screens/register_screen.dart';
import 'package:my_app/screens/walkthrough.dart';
import 'package:my_app/screens/MyProfile.dart';
import 'package:my_app/screens/MyCollection.dart';
import 'package:my_app/screens/collaborate_screen.dart';
import 'package:my_app/screens/404.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Retrieve walkthrough status from SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final bool walkthroughCompleted =
      prefs.getBool('walkthroughCompleted') ?? false;

  runApp(
    ProviderScope(
      child: MyApp(walkthroughCompleted: walkthroughCompleted),
    ),
  );
}

class MyApp extends ConsumerWidget {
  final bool walkthroughCompleted;
  const MyApp({super.key, required this.walkthroughCompleted});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch themeProvider state to rebuild on theme changes
    ref.watch(themeProvider);
    // Access themeData from ThemeNotifier
    final themeData = ref.read(themeProvider.notifier).themeData;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login App',
      theme: themeData,
      initialRoute: walkthroughCompleted ? '/login' : '/walkthrough',
      routes: {
        '/walkthrough': (context) => const Walkthrough(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const RegisterScreen(),
        '/': (context) => const MainScreen(index: 0),
        '/home': (context) => const HomeScreen(),
        '/myprofile': (context) => const MyProfile(),
        '/mycollection': (context) => const MyCollection(),
        '/collaborate': (context) => const CollaborateScreen(),
        '/profile_settings': (context) => const ProfileSettings(),
        '/following': (context) => const Following(),
        '/store_details': (context) => const StoreDetailsScreen(storeId: 2),
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => const NotFoundPage(),
      ),
    );
  }
}