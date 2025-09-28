import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: ListView(
        children: [
          SwitchListTile(
              value: true, onChanged: (v) {}, title: const Text('Notificaciones')),
          const ListTile(title: Text('Idioma')),
          const ListTile(title: Text('Acerca de')),
        ],
      ),
    );
  }
}
