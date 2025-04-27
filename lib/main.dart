import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/main_screen.dart';
import 'package:my_app/providers/theme_provider.dart';
import 'package:my_app/screens/home.dart';
import 'package:my_app/screens/profileSettings.dart';
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
  const MyApp({Key? key, required this.walkthroughCompleted}) : super(key: key);

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
        '/login': (context) => LoginScreen(),
        '/signup': (context) => RegisterScreen(),
        '/': (context) => MainScreen(index: 0),
        '/home': (context) => HomeScreen(),
        '/myprofile': (context) => MyProfile(),
        '/mycollection': (context) => MyCollection(),
        '/collaborate': (context) => CollaborateScreen(),
        '/profile_settings': (context) => ProfileSettings(),
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => NotFoundPage(),
      ),
    );
  }
}