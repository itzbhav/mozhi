import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReadingScreen extends StatefulWidget {
  final String language;

  ReadingScreen({required this.language});

  @override
  _ReadingScreenState createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  List<Map<String, dynamic>> _questions = [];
  int _currentIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('lessons')
          .doc(widget.language.toLowerCase())
          .collection('words')
          .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          _questions = snapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching lessons: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void checkAnswer(String selectedOption) {
    String correctAnswer = _questions[_currentIndex]['correct'];

    if (selectedOption == correctAnswer) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Correct! 🎉", style: TextStyle(fontSize: 16))),
      );
      setState(() {
        if (_currentIndex < _questions.length - 1) {
          _currentIndex++;
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Wrong! Try Again ❌", style: TextStyle(fontSize: 16))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reading - ${widget.language}"),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.home, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/home'); // Replace '/home' with your actual home route
            },
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            "assets/image1.png",
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.0),
          ),
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _questions.isEmpty
                  ? Center(
                      child: Text(
                        "No lessons available for ${widget.language}",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Translate:",
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          SizedBox(height: 10),
                          Text(
                            _questions[_currentIndex]['text'],
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.yellow),
                          ),
                          SizedBox(height: 30),
                          ...List.generate(_questions[_currentIndex]['options'].length, (index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: ElevatedButton(
                                onPressed: () => checkAnswer(_questions[_currentIndex]['options'][index]),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                                  shadowColor: Colors.black,
                                  elevation: 5,
                                ),
                                child: Text(
                                  _questions[_currentIndex]['options'][index],
                                  style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
        ],
      ),
    );
  }
}
