import 'package:flutter/material.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Programar")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Tareas programadas",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.event_note, color: Colors.green),
              title: const Text("Visita de campo"),
              subtitle: const Text("28/09/2025 - 9:00 AM"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.alarm, color: Colors.green),
              title: const Text("Aplicar fertilizante"),
              subtitle: const Text("01/10/2025 - 6:00 AM"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
