import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore for storing leaderboard data
import 'firebase_options.dart';

import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/register_screen.dart';
import 'screens/reading_screen.dart';
import 'screens/listening_screen.dart';
import 'screens/speaking_screen.dart';
import 'screens/writing_screen.dart';
import 'screens/leaderboard_screen.dart';
import 'screens/translator_screen.dart';
import 'screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await addDefaultUsers(); // Add default leaderboard users on startup
  runApp(const LanguageLearningApp());
}

Future<void> addDefaultUsers() async {
  final users = [
    {"username": "Bhavatharini", "loginCount": 50},
    {"username": "Pranav", "loginCount": 45},
    {"username": "Keerthana", "loginCount": 40},
    {"username": "Srihari", "loginCount": 35},
    {"username": "Rithika", "loginCount": 30},
  ];

  final userCollection = FirebaseFirestore.instance.collection('users');

  for (var user in users) {
    // Check if the user already exists to avoid duplicates
    var querySnapshot = await userCollection
        .where('username', isEqualTo: user['username'])
        .get();

    if (querySnapshot.docs.isEmpty) {
      await userCollection.add(user);
    }
  }
}

class LanguageLearningApp extends StatelessWidget {
  const LanguageLearningApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Language Learning App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      initialRoute: '/', // Start with splash screen
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/listening': (context) => ListeningScreen(language: "Hindi"),
        '/speaking': (context) => SpeakingScreen(language: "Hindi"),
        '/writing': (context) => WritingScreen(language: "Hindi"),
        '/leaderboard': (context) => LeaderboardScreen(),
        '/translator': (context) => TranslatorScreen(),
        '/settings': (context) => SettingsScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/reading') {
          final args = settings.arguments as Map<String, String>? ?? {};
          return MaterialPageRoute(
            builder: (context) => ReadingScreen(language: args['language'] ?? 'Hindi'),
          );
        }
        return null;
      },
    );
  }
}
