import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../main.dart'; // Import to access themeNotifier

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HearAble'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          // Theme Toggle Button
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeNotifier,
            builder: (context, mode, child) {
              return IconButton(
                icon: Icon(
                  mode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
                ),
                tooltip: 'Toggle Theme',
                onPressed: () {
                  themeNotifier.value = mode == ThemeMode.dark
                      ? ThemeMode.light
                      : ThemeMode.dark;
                },
              );
            },
          ),
          // Logout Button
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => context.go('/login'),
          ),
        ],
      ),
      // Drawer removed as requested
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _FeatureCard(
              title: 'Sign Language',
              icon: Icons.back_hand,
              color: Colors.blue,
              onTap: () => context.push('/sign-language'),
            ),
            _FeatureCard(
              title: 'Speech & Emotion',
              icon: Icons.record_voice_over,
              color: Colors.orange,
              onTap: () => context.push('/speech-emotion'),
            ),
            _FeatureCard(
              title: 'Lip Reading',
              icon: Icons.face,
              color: Colors.pink,
              onTap: () => context.push('/lip-reading'),
            ),
            _FeatureCard(
              title: 'Sign Library',
              icon: Icons.library_books,
              color: Colors.green,
              onTap: () => context.push('/sign-library'),
            ),
            _FeatureCard(
              title: 'Alert Library',
              icon: Icons.warning,
              color: Colors.red,
              onTap: () => context.push('/alert-library'),
            ),
            _FeatureCard(
              title: 'Speech to Text',
              icon: Icons.mic,
              color: Colors.teal,
              onTap: () => context.push('/speech-to-text'),
            ),
            _FeatureCard(
              title: 'Sign Description',
              icon: Icons.description,
              color: Colors.purple,
              onTap: () => context.push('/sign-description'),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: color),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
