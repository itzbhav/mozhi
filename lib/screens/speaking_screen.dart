import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeakingScreen extends StatefulWidget {
  final String language;

  SpeakingScreen({required this.language});

  @override
  _SpeakingScreenState createState() => _SpeakingScreenState();
}

class _SpeakingScreenState extends State<SpeakingScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _spokenText = "";
  String _feedbackMessage = "";
  int _currentIndex = 0;
  bool _waitingForNextWord = false; // 🚀 Prevents jumping back & forth

  // ✅ Predefined words for each language
  final Map<String, List<String>> languageWords = {
    "hindi": ["नमस्ते", "धन्यवाद", "माफ़ कीजिए", "हाँ", "नहीं"],
    "french": ["Bonjour", "Merci", "Pardon", "Oui", "Non"],
    "spanish": ["Hola", "Gracias", "Perdón", "Sí", "No"]
  };

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void startListening() async {
    if (_waitingForNextWord) return; // 🚀 Prevents multiple updates

    bool available = await _speech.initialize(
      onStatus: (status) => print("Speech Status: $status"),
      onError: (error) => print("Speech Error: $error"),
    );

    if (available) {
      setState(() {
        _isListening = true;
        _spokenText = "";
        _feedbackMessage = "";
      });

      _speech.listen(
        onResult: (result) {
          setState(() {
            _spokenText = result.recognizedWords;
          });

          checkPronunciation();
        },
        localeId: getLocaleId(widget.language),
      );
    } else {
      setState(() {
        _feedbackMessage = "❌ Speech recognition not available!";
      });
    }
  }

  void stopListening() {
    _speech.stop();
    setState(() {
      _isListening = false;
    });
  }

  void checkPronunciation() {
    if (_waitingForNextWord) return; // 🚀 Prevent multiple checks

    String correctWord = languageWords[widget.language.toLowerCase()]?[_currentIndex] ?? "";

    if (_spokenText.toLowerCase().trim() == correctWord.toLowerCase().trim()) {
      setState(() {
        _feedbackMessage = "✅ Correct pronunciation!";
      });
    } else {
      setState(() {
        _feedbackMessage = "❌ Incorrect pronunciation! Let's come back later.";
      });
    }

    // 🚀 Move to the next word after 2 seconds
    _waitingForNextWord = true;
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        if (_currentIndex < languageWords[widget.language.toLowerCase()]!.length - 1) {
          _currentIndex++;
        } else {
          _currentIndex = 0; // Restart after all words are done
        }
        _spokenText = "";
        _feedbackMessage = "";
        _waitingForNextWord = false; // 🚀 Ready for next word
      });
    });
  }

  String getLocaleId(String language) {
    switch (language.toLowerCase()) {
      case "hindi":
        return "hi-IN";
      case "french":
        return "fr-FR";
      case "spanish":
        return "es-ES";
      default:
        return "en-US";
    }
  }

  @override
  Widget build(BuildContext context) {
    String correctWord = languageWords[widget.language.toLowerCase()]?[_currentIndex] ?? "";

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            "assets/image1.png",
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.5), // Overlay for readability
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Pronounce the Word:",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 10),
                Text(
                  correctWord,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.yellow),
                ),
                SizedBox(height: 30),
                _isListening
                    ? Text(
                        "🎤 Listening...",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )
                    : Text(
                        _spokenText.isNotEmpty ? "You said: $_spokenText" : "Press the mic to start",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                SizedBox(height: 20),
                _feedbackMessage.isNotEmpty
                    ? Text(
                        _feedbackMessage,
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
                      )
                    : Container(),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isListening ? stopListening : startListening,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                    shadowColor: Colors.black,
                    elevation: 5,
                  ),
                  child: Icon(
                    _isListening ? Icons.mic_off : Icons.mic,
                    color: Colors.black,
                    size: 40,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
