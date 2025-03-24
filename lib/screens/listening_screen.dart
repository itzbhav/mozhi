import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class ListeningScreen extends StatefulWidget {
  final String language;

  const ListeningScreen({Key? key, required this.language}) : super(key: key);

  @override
  _ListeningScreenState createState() => _ListeningScreenState();
}

class _ListeningScreenState extends State<ListeningScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int _currentIndex = 0;
  String _selectedAnswer = "";
  bool _isAnswered = false;

  final Map<String, List<Map<String, dynamic>>> _questionsByLanguage = {
    "Hindi": [
      {
        "audio": "assets/audio/hindi_q1.mp3",
        "correct": "बिल्ली सो रही है (The cat is sleeping)",
        "options": ["बिल्ली खा रही है (The cat is eating)", "बिल्ली सो रही है (The cat is sleeping)", "कुत्ता सो रहा है (The dog is sleeping)"]
      },
      {
        "audio": "assets/audio/hindi_q2.mp3",
        "correct": "क्या तुम पानी पी रहे हो? (Are you drinking water?)",
        "options": ["क्या तुम खाना खा रहे हो? (Are you eating food?)", "क्या तुम पानी पी रहे हो? (Are you drinking water?)", "क्या तुम सो रहे हो? (Are you sleeping?)"]
      }
    ],
    "French": [
      {
        "audio": "assets/audio/french_q2.mp3",
        "correct": "Bonjour Madame (Good day, Ma'am)",
        "options": ["Bonsoir Monsieur (Good evening, Sir)", "Bonjour Madame (Good day, Ma'am)", "Bienvenue (Welcome)"]
      },
      {
        "audio": "assets/audio/french_q1.mp3",
        "correct": "Le garçon mange une pomme. (The boy is eating an apple.)",
        "options": ["Le garçon boit de l'eau. (The boy is drinking water.)", "La fille mange une pomme. (The girl is eating an apple.)", "Le garçon mange une pomme. (The boy is eating an apple.)"]
      }
    ],
    "Spanish": [
      {
        "audio": "assets/audio/spanish_q1.mp3",
        "correct": "Buenos días (Good morning)",
        "options": ["Buenas tardes (Good afternoon)", "Buenas noches (Good night)", "Buenos días (Good morning)"]
      },
      {
        "audio": "assets/audio/spanish_q2.mp3",
        "correct": "La niña bebe agua. (The girl is drinking water.)",
        "options": ["El niño bebe agua. (The boy is drinking water.)", "La niña come una manzana. (The girl is eating an apple.)", "La niña bebe agua. (The girl is drinking water.)"]
      }
    ]
  };

  late List<Map<String, dynamic>> _questions;

  void _playAudio(String path) async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(path));
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  void _checkAnswer(String selected) {
    setState(() {
      _selectedAnswer = selected;
      _isAnswered = true;
    });

    Future.delayed(Duration(seconds: 1), () {
      if (selected == _questions[_currentIndex]["correct"]) {
        _showMessage("✅ Correct! Moving to next.");
      } else {
        _showMessage("❌ Incorrect! Try again.");
      }
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message, style: TextStyle(fontSize: 16)),
      duration: Duration(seconds: 2),
    ));

    Future.delayed(Duration(seconds: 2), () {
      if (_selectedAnswer == _questions[_currentIndex]["correct"]) {
        setState(() {
          if (_currentIndex < _questions.length - 1) {
            _currentIndex++;
            _isAnswered = false;
            _selectedAnswer = "";
            _playAudio(_questions[_currentIndex]["audio"]);
          }
        });
      } else {
        setState(() {
          _isAnswered = false;
          _selectedAnswer = "";
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _questions = _questionsByLanguage[widget.language] ?? [];
    if (_questions.isNotEmpty) {
      _playAudio(_questions[_currentIndex]["audio"]);
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Listening Exercise"),
          leading: IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.pop(context); // Navigates back to Home Screen
            },
          ),
        ),
        body: Center(
          child: Text("No questions available for ${widget.language}"),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Listening Exercise"),
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Navigator.pop(context); // Navigates back to Home Screen
          },
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/image1.png",
            fit: BoxFit.cover,
          ),
          Container(color: Colors.black.withOpacity(0.5)), // Overlay

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Language: ${widget.language}",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 10),

                Text(
                  "Listen to the word and choose the correct answer:",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                SizedBox(height: 20),

                ElevatedButton.icon(
                  onPressed: () => _playAudio(_questions[_currentIndex]["audio"]),
                  icon: Icon(Icons.play_arrow),
                  label: Text("Play Audio"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                ),
                SizedBox(height: 30),

                ..._questions[_currentIndex]["options"].map<Widget>((option) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      onPressed: _isAnswered ? null : () => _checkAnswer(option),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isAnswered
                            ? (option == _questions[_currentIndex]["correct"]
                                ? Colors.green
                                : (option == _selectedAnswer ? Colors.red : Colors.white))
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                      ),
                      child: Text(
                        option,
                        style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
