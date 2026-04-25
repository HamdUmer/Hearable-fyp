import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class AudioClassifierService {
  Interpreter? _interpreter;
  List<String> _labels = [];

  // Sounds we care about for alerts (mapped from YAMNet class names)
  static const Map<String, Map<String, dynamic>> alertSounds = {
    'Smoke detector': {
      'icon': '🔥',
      'color': 0xFFE53935,
      'message': 'Fire alarm detected!',
    },
    'Fire alarm': {
      'icon': '🔥',
      'color': 0xFFE53935,
      'message': 'Fire alarm detected!',
    },
    'Doorbell': {
      'icon': '🔔',
      'color': 0xFF1E88E5,
      'message': 'Someone at the door!',
    },
    'Knock': {
      'icon': '🚪',
      'color': 0xFF1E88E5,
      'message': 'Knocking detected!',
    },
    'Dog': {
      'icon': '🐕',
      'color': 0xFFFB8C00,
      'message': 'Dog barking nearby!',
    },
    'Bark': {
      'icon': '🐕',
      'color': 0xFFFB8C00,
      'message': 'Dog barking nearby!',
    },
    'Baby cry': {'icon': '👶', 'color': 0xFF8E24AA, 'message': 'Baby crying!'},
    'Crying': {'icon': '👶', 'color': 0xFF8E24AA, 'message': 'Baby crying!'},
    'Siren': {'icon': '🚨', 'color': 0xFFE53935, 'message': 'Emergency siren!'},
    'Alarm': {'icon': '⏰', 'color': 0xFFFDD835, 'message': 'Alarm detected!'},
    'Glass': {'icon': '💥', 'color': 0xFF6D4C41, 'message': 'Breaking glass!'},
    'Explosion': {
      'icon': '💥',
      'color': 0xFFE53935,
      'message': 'Loud explosion!',
    },
  };

  Future<void> initialize() async {
    // Load model
    _interpreter = await Interpreter.fromAsset('assets/models/yamnet.tflite');

    // Load labels from CSV
    final csv = await rootBundle.loadString('assets/yamnet_class_map.csv');
    _labels = csv
        .split('\n')
        .skip(1) // skip header row
        .map(
          (line) => line.split(',').length > 2 ? line.split(',')[2].trim() : '',
        )
        .where((label) => label.isNotEmpty)
        .toList();
  }

  // Takes raw audio bytes, returns detected alert or null
  Map<String, dynamic>? classify(List<double> audioSamples) {
    if (_interpreter == null || _labels.isEmpty) return null;

    // YAMNet expects exactly 15600 float32 samples (1 second at 16kHz)
    final input = [audioSamples];
    final output = List.filled(521, 0.0).reshape([1, 521]);

    _interpreter!.run(input, output);

    // Find the highest scoring class
    final scores = output[0] as List<double>;
    double maxScore = 0;
    int maxIndex = 0;
    for (int i = 0; i < scores.length; i++) {
      if (scores[i] > maxScore) {
        maxScore = scores[i];
        maxIndex = i;
      }
    }

    // Only report if confidence is above 40%
    if (maxScore < 0.4) return null;

    final detectedLabel = maxIndex < _labels.length ? _labels[maxIndex] : '';

    // Check if it matches any of our alert sounds
    for (final alertKey in alertSounds.keys) {
      if (detectedLabel.toLowerCase().contains(alertKey.toLowerCase())) {
        return {
          ...alertSounds[alertKey]!,
          'label': detectedLabel,
          'confidence': (maxScore * 100).toStringAsFixed(0),
        };
      }
    }

    return null; // not an alert sound
  }

  void dispose() {
    _interpreter?.close();
  }
}
