import 'package:flutter/material.dart';

class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({Key? key}) : super(key: key);

  @override
  _TranslatorScreenState createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  final TextEditingController _controller = TextEditingController();
  String selectedLanguage = "French";
  String translatedText = "";

  final Map<String, Map<String, String>> translations = {
    "water": {"French": "eau", "Spanish": "agua", "Hindi": "पानी"},
    "hello": {"French": "bonjour", "Spanish": "hola", "Hindi": "नमस्ते"},
    "thank you": {"French": "merci", "Spanish": "gracias", "Hindi": "धन्यवाद"},
    "yes": {"French": "oui", "Spanish": "sí", "Hindi": "हाँ"},
    "no": {"French": "non", "Spanish": "no", "Hindi": "नहीं"},
    "please": {"French": "s'il vous plaît", "Spanish": "por favor", "Hindi": "कृपया"},
    "goodbye": {"French": "au revoir", "Spanish": "adiós", "Hindi": "अलविदा"},
    "friend": {"French": "ami", "Spanish": "amigo", "Hindi": "दोस्त"},
    "love": {"French": "amour", "Spanish": "amor", "Hindi": "प्यार"},
    "food": {"French": "nourriture", "Spanish": "comida", "Hindi": "खाना"},
    "book": {"French": "livre", "Spanish": "libro", "Hindi": "किताब"},
  };

  void translate() {
    String input = _controller.text.trim().toLowerCase();
    setState(() {
      translatedText = translations[input]?[selectedLanguage] ?? "Translation not available";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Translator"), backgroundColor: Colors.purple),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: "Enter a word in English"),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedLanguage,
              onChanged: (newValue) {
                setState(() => selectedLanguage = newValue!);
              },
              items: ["French", "Spanish", "Hindi"].map((lang) {
                return DropdownMenuItem(value: lang, child: Text(lang));
              }).toList(),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: translate,
              child: const Text("Translate"),
            ),
            const SizedBox(height: 20),
            Text(translatedText, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
