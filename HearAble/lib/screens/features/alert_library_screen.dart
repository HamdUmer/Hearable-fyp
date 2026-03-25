import 'package:flutter/material.dart';

class AlertLibraryScreen extends StatelessWidget {
  const AlertLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alert Library')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 8,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: Colors.red.withAlpha(25),
                child: const Icon(
                  Icons.notifications_active,
                  color: Colors.red,
                ),
              ),
              title: Text(
                'Alert Type ${index + 1}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('Detects specific sound patterns'),
              trailing: Switch(
                value: index % 2 == 0,
                onChanged: (val) {},
                activeTrackColor: Colors.blue,
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
