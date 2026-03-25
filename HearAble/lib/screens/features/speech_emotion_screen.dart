import 'package:flutter/material.dart';

class SpeechEmotionScreen extends StatelessWidget {
  const SpeechEmotionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Speech & Emotion')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Spacer(),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue.withAlpha(25),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Icon(Icons.graphic_eq, size: 100, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Detected Emotion:',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            const Text(
              'Happy',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: 80,
              height: 80,
              child: FloatingActionButton(
                onPressed: () {},
                backgroundColor: Colors.blue,
                child: const Icon(Icons.mic, size: 40),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Tap to Listen'),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
