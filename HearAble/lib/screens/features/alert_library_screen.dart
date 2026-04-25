import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../services/audio_classifier_service.dart';
import 'dart:async';

class AlertLibraryScreen extends StatefulWidget {
  const AlertLibraryScreen({super.key});

  @override
  State<AlertLibraryScreen> createState() => _AlertLibraryScreenState();
}

class _AlertLibraryScreenState extends State<AlertLibraryScreen> {
  final AudioClassifierService _classifier = AudioClassifierService();
  final AudioRecorder _recorder = AudioRecorder();

  bool _isListening = false;
  bool _isModelReady = false;
  final List<Map<String, dynamic>> _alertHistory = [];
  StreamSubscription<Uint8List>? _audioStreamSub;

  final List<Map<String, dynamic>> _watchList = [
    {'name': 'Fire Alarm',     'icon': '🔥', 'color': Colors.red,    'enabled': true},
    {'name': 'Doorbell',       'icon': '🔔', 'color': Colors.blue,   'enabled': true},
    {'name': 'Dog Barking',    'icon': '🐕', 'color': Colors.orange, 'enabled': true},
    {'name': 'Baby Crying',    'icon': '👶', 'color': Colors.purple, 'enabled': true},
    {'name': 'Siren',          'icon': '🚨', 'color': Colors.red,    'enabled': true},
    {'name': 'Breaking Glass', 'icon': '💥', 'color': Colors.brown,  'enabled': false},
    {'name': 'Alarm',          'icon': '⏰', 'color': Colors.yellow, 'enabled': true},
    {'name': 'Knocking',       'icon': '🚪', 'color': Colors.blue,   'enabled': false},
  ];

  @override
  void initState() {
    super.initState();
    _initModel();
  }

  Future<void> _initModel() async {
    await _classifier.initialize();
    if (mounted) setState(() => _isModelReady = true);
  }

  Future<void> _toggleListening() async {
    if (_isListening) {
      _stopListening();
    } else {
      await _startListening();
    }
  }

  Future<void> _startListening() async {
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      _showSnack('Microphone permission is required.');
      return;
    }

    final List<double> audioBuffer = [];

    final stream = await _recorder.startStream(
      const RecordConfig(
        encoder: AudioEncoder.pcm16bits,
        sampleRate: 16000,
        numChannels: 1,
      ),
    );

    setState(() => _isListening = true);

    _audioStreamSub = stream.listen((Uint8List bytes) {
      // Convert raw bytes → float samples (-1.0 to 1.0)
      for (int i = 0; i < bytes.length - 1; i += 2) {
        final int16 = bytes[i] | (bytes[i + 1] << 8);
        final signed = int16 > 32767 ? int16 - 65536 : int16;
        audioBuffer.add(signed / 32768.0);
      }

      // Once we have 1 second of audio (15600 samples at 16kHz), run YAMNet
      if (audioBuffer.length >= 15600) {
        final samples = audioBuffer.sublist(0, 15600);
        audioBuffer.removeRange(0, 15600);

        final alert = _classifier.classify(samples);

        if (alert != null && mounted) {
          final isEnabled = _watchList.any((item) =>
              alert['message']
                  .toString()
                  .toLowerCase()
                  .contains(item['name'].toString().toLowerCase()) &&
              item['enabled'] == true);

          if (isEnabled) {
            setState(() {
              _alertHistory.insert(0, {
                ...alert,
                'time': TimeOfDay.now().format(context),
              });
              if (_alertHistory.length > 20) _alertHistory.removeLast();
            });
            _showAlertBanner(alert);
          }
        }
      }
    });
  }

  void _stopListening() {
    _audioStreamSub?.cancel();
    _audioStreamSub = null;
    _recorder.stop();
    setState(() => _isListening = false);
  }

  void _showAlertBanner(Map<String, dynamic> alert) {
    // Fix: use Color directly instead of deprecated .value
    final Color bannerColor = alert['color'] is Color
        ? alert['color'] as Color
        : Color(alert['color']);

    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        backgroundColor: bannerColor,
        content: Row(
          children: [
            Text(alert['icon'], style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    alert['message'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '${alert['confidence']}% confidence',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () =>
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
            child: const Text('DISMISS', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
    });
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    _stopListening();
    _classifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alert Library')),
      body: !_isModelReady
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading YAMNet model...'),
                ],
              ),
            )
          : Column(
              children: [
                // ── Listen Toggle Card ─────────────────────────
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _isListening
                        ? Colors.red.withAlpha(20)
                        : Colors.blue.withAlpha(20),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _isListening ? Colors.red : Colors.blue,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isListening ? Icons.mic : Icons.mic_off,
                        color: _isListening ? Colors.red : Colors.blue,
                        size: 32,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isListening ? 'Listening...' : 'Not Listening',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _isListening ? Colors.red : Colors.blue,
                              ),
                            ),
                            Text(
                              _isListening
                                  ? 'YAMNet is monitoring audio'
                                  : 'Tap to start monitoring',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      // Fix: replaced deprecated activeColor with activeThumbColor
                      Switch(
                        value: _isListening,
                        onChanged: (_) => _toggleListening(),
                        activeThumbColor: Colors.red,
                      ),
                    ],
                  ),
                ),

                // ── Tabs ──────────────────────────────────────
                Expanded(
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        const TabBar(
                          tabs: [
                            Tab(text: 'Watch List'),
                            Tab(text: 'Alert History'),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              _buildWatchList(),
                              _buildAlertHistory(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildWatchList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _watchList.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = _watchList[index];
        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: (item['color'] as Color).withAlpha(25),
              child: Text(item['icon'], style: const TextStyle(fontSize: 20)),
            ),
            title: Text(
              item['name'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('YAMNet detection enabled'),
            trailing: Switch(
              value: item['enabled'],
              // Fix: replaced deprecated activeColor with activeThumbColor
              activeThumbColor: Colors.blue,
              onChanged: (val) {
                setState(() => _watchList[index]['enabled'] = val);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildAlertHistory() {
    if (_alertHistory.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_none, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No alerts detected yet',
                style: TextStyle(color: Colors.grey, fontSize: 16)),
            SizedBox(height: 8),
            Text('Start listening to detect sounds',
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _alertHistory.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final alert = _alertHistory[index];
        final Color alertColor = alert['color'] is Color
            ? alert['color'] as Color
            : Color(alert['color']);
        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: alertColor.withAlpha(30),
              child: Text(alert['icon'], style: const TextStyle(fontSize: 20)),
            ),
            title: Text(alert['message'],
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${alert['confidence']}% confidence'),
            trailing: Text(alert['time'],
                style: const TextStyle(color: Colors.grey)),
          ),
        );
      },
    );
  }
}