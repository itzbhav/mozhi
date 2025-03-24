import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WritingScreen extends StatefulWidget {
  final String language;

  const WritingScreen({Key? key, required this.language}) : super(key: key);

  @override
  _WritingScreenState createState() => _WritingScreenState();
}

class _WritingScreenState extends State<WritingScreen> {
  String paragraph = "";
  String question = "";
  List<String> options = [];
  String correctAnswer = "";
  String selectedAnswer = "";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWritingLesson();
  }

  Future<void> fetchWritingLesson() async {
    try {
      String docId = "${widget.language.toLowerCase()}_writing_1"; // e.g., "hindi_writing_1"
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection("writing_lessons")
          .doc(docId)
          .get();

      if (document.exists) {
        setState(() {
          paragraph = document["paragraph"];
          question = document["question"];
          options = List<String>.from(document["options"]);
          correctAnswer = document["correct_answer"];
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching writing lesson: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void checkAnswer(String option) {
    setState(() {
      selectedAnswer = option;
    });

    if (option == correctAnswer) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Correct! 🎉", style: TextStyle(fontSize: 16))),
      );
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
        title: Text("Writing Exercise"),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            icon: Icon(Icons.home, color: Colors.white), // Home Icon
            onPressed: () {
              Navigator.pushNamed(context, '/home'); // Navigate to Home Screen
            },
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          /// **Background Image**
          Image.asset(
            "assets/image1.png", // ✅ Ensure it's in pubspec.yaml
            fit: BoxFit.cover,
          ),
          
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : paragraph.isEmpty
                  ? Center(
                      child: Text(
                        "No writing lesson available for ${widget.language}",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          /// **Paragraph Display**
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7), // ✅ Readable background
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "Read the Paragraph:",
                                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  paragraph,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 18, color: Colors.yellow, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),

                          /// **Question**
                          Text(
                            "Question:",
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          SizedBox(height: 10),
                          Text(
                            question,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          SizedBox(height: 30),

                          /// **Answer Selection**
                          ...options.map((option) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: ElevatedButton(
                                  onPressed: () => checkAnswer(option),
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
                                    option,
                                    style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
        ],
      ),
    );
  }
}
