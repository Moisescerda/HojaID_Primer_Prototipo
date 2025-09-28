import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> notifs = [
      {"title": "Alerta de clima", "subtitle": "Posible lluvia mañana"},
      {"title": "Nueva recomendación",
        "subtitle": "Revisa el tratamiento sugerido para maíz"},
      {"title": "Recordatorio",
        "subtitle": "Riego programado para hoy a las 5PM"},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Notificaciones")),
      body: ListView.separated(
        itemCount: notifs.length,
        separatorBuilder: (_, __) => const Divider(height: 0),
        itemBuilder: (_, i) {
          final n = notifs[i];
          return ListTile(
            leading: const Icon(Icons.notifications, color: Colors.green),
            title: Text(n["title"]!),
            subtitle: Text(n["subtitle"]!),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          );
        },
      ),
    );
  }
}
