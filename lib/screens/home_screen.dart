import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'reading_screen.dart'; 
import 'listening_screen.dart';
import 'speaking_screen.dart';
import 'writing_screen.dart';
import 'leaderboard_screen.dart';
import 'translator_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  String _selectedLang = "Hindi"; // Default Language

  List<Map<String, dynamic>> get _learningOptions => [
        {
          "title": "Reading",
          "icon": "assets/home_icons/reading.png",
          "screen": ReadingScreen(language: _selectedLang),
        },
        {
          "title": "Listening",
          "icon": "assets/home_icons/listening.png",
          "screen": ListeningScreen(language: _selectedLang ),
        },
        {
          "title": "Speaking",
          "icon": "assets/home_icons/speaking.png",
          "screen": SpeakingScreen(language: _selectedLang),
        },
        {
          "title": "Writing",
          "icon": "assets/home_icons/writing.png",
          "screen": WritingScreen(language: _selectedLang ?? "Hindi"),
        },
      ];

  List<Map<String, String>> _languages = [
    {"name": "Hindi", "flag": "in"},
    {"name": "French", "flag": "fr"},
    {"name": "Spanish", "flag": "es"},
  ];

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    Widget? selectedScreen;
    switch (index) {
      case 1:
        selectedScreen = LeaderboardScreen();
        break;
      case 2:
        selectedScreen = TranslatorScreen();
        break;
      case 3:
        selectedScreen = SettingsScreen();
        break;
    }

    if (selectedScreen != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => selectedScreen!), // ✅ Fixed nullable issue
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[200],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Welcome, Bhavatharini!", style: TextStyle(color: Colors.white)),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: _selectedLang,
              icon: Icon(Icons.language, color: Colors.white),
              dropdownColor: Colors.deepPurple,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLang = newValue!;
                });
              },
              items: _languages.map<DropdownMenuItem<String>>((lang) {
                return DropdownMenuItem<String>(
                  value: lang["name"],
                  child: Row(
                    children: [
                      SvgPicture.asset("assets/flag/${lang['flag']}.svg", width: 25),
                      SizedBox(width: 10),
                      Text(lang["name"]!),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Continue learning $_selectedLang",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                itemCount: _learningOptions.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => _learningOptions[index]['screen'], // ✅ Correct navigation
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(_learningOptions[index]['icon']!, height: 60, width: 60),
                          SizedBox(height: 10),
                          Text(_learningOptions[index]['title']!, style: TextStyle(fontWeight: FontWeight.bold)),
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: LinearPercentIndicator(
                              animation: true,
                              lineHeight: 4,
                              backgroundColor: Colors.purple[100]!,
                              barRadius: Radius.circular(20),
                              progressColor: Colors.deepPurple,
                              percent: 0.5, // Example progress
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(6),
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: GNav(
          duration: Duration(milliseconds: 800),
          tabBorderRadius: 20,
          tabMargin: EdgeInsets.all(3),
          color: Colors.white70,
          tabBackgroundColor: Colors.purple.shade300,
          activeColor: Colors.white,
          backgroundColor: Colors.deepPurple,
          selectedIndex: _selectedIndex,
          onTabChange: _onBottomNavTap,
          tabs: [
            GButton(icon: Icons.home, text: "Home"),
            GButton(icon: Icons.leaderboard, text: "Leaderboard"),
            GButton(icon: Icons.translate, text: "Translator"),
            GButton(icon: Icons.settings, text: "Settings"),
          ],
        ),
      ),
    );
  }
}
