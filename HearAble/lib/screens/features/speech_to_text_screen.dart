import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechToTextScreen extends StatefulWidget {
  const SpeechToTextScreen({super.key});

  @override
  Speechtextstate createState() => Speechtextstate();
}

class Speechtextstate extends State<SpeechToTextScreen> {
  bool islistening = false;
  late stt.SpeechToText _speechToText;
  String text = "Press the button and start speaking";
  double confidence = 1.0;

  @override
  void initState() {
    _speechToText = stt.SpeechToText();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Speech to Text')),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: SingleChildScrollView(
                child: Text(
                  text,
                  style: const TextStyle(fontSize: 20, color: Colors.grey),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.history, size: 30),
                  color: Colors.grey,
                ),
                FloatingActionButton.large(
                  onPressed: capturevoice,
                  backgroundColor: Colors.blue,
                  child: Icon(
                    islistening ? Icons.mic : Icons.mic_none,
                    size: 40,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.settings, size: 30),
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void capturevoice() async {
    if (!islistening) {
      bool available = await _speechToText.initialize();
      if (available) {
        setState(() => islistening = true);
        _speechToText.listen(
          onResult: (result) => setState(() {
            text = result.recognizedWords;
            if (result.hasConfidenceRating && result.confidence > 0) {
              confidence = result.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => islistening = false);
      _speechToText.stop();
    }
  }
}
