import 'package:flutter/material.dart';

class LipReadingScreen extends StatelessWidget {
  const LipReadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lip Reading')),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Center(
                    child: Icon(Icons.face, size: 100, color: Colors.white24),
                  ),
                  Positioned(
                    bottom: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.circle, size: 12, color: Colors.white),
                          SizedBox(width: 8),
                          Text('REC', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Transcribed Text:',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  const Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        'This is where the lip reading transcription will appear in real-time as the user speaks.',
                        style: TextStyle(fontSize: 24, height: 1.5),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.copy),
                        tooltip: 'Copy',
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.volume_up),
                        tooltip: 'Speak',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
