import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LearningScreen extends StatefulWidget {
  final String language;

  LearningScreen({required this.language});

  @override
  _LearningScreenState createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  List<Map<String, dynamic>> _questions = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  // Fetch lesson data from Firestore
  Future<void> loadQuestions() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('lessons')
        .doc(widget.language.toLowerCase()) // Ensure correct language selection
        .collection('words')
        .get();

    setState(() {
      _questions = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }

  // Handle answer checking
  void checkAnswer(String selectedOption) {
    String correctAnswer = _questions[_currentIndex]['correct'];

    if (selectedOption == correctAnswer) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Correct! 🎉")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Wrong! Try Again ❌")));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("Learn ${widget.language}")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    Map<String, dynamic> question = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(title: Text("Learn ${widget.language}")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Translate: ${question['text']}",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ...List.generate(question['options'].length, (index) {
            return ElevatedButton(
              onPressed: () => checkAnswer(question['options'][index]),
              child: Text(question['options'][index]),
            );
          })
        ],
      ),
    );
  }
}
