import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/task_store.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final store = CalendarStore.instance;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Aviso en-app cuando una tarea está por vencer (ejecución en primer plano)
    _timer = Timer.periodic(const Duration(minutes: 1), (_) => _checkDueSoon());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _checkDueSoon() {
    final now = DateTime.now();
    final soon = now.add(const Duration(minutes: 1));
    final due = store
        .allUpcoming()
        .where((t) => !t.done && t.dateTime.isAfter(now) && t.dateTime.isBefore(soon))
        .toList();
    if (due.isNotEmpty && mounted) {
      final first = due.first;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('📅 ${first.title} a las ${first.time.format(context)}'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notificaciones")),
      body: AnimatedBuilder(
        animation: store,
        builder: (_, __) {
          final upcoming = store.allUpcoming();

          if (upcoming.isEmpty) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Sin recordatorios próximos. Programa actividades en el Calendario.'),
                  ),
                ),
              ],
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: upcoming.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) {
              final t = upcoming[i];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.notifications_active_outlined),
                  title: Text(
                    t.title,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                      '${t.date.day}/${t.date.month}/${t.date.year} • ${t.time.format(context)}${t.notes == null ? '' : ' • ${t.notes}'}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: t.done ? 'Marcar pendiente' : 'Marcar hecho',
                        icon: Icon(t.done ? Icons.undo : Icons.check),
                        onPressed: () => store.toggleDone(t.id),
                      ),
                      IconButton(
                        tooltip: 'Eliminar',
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => store.removeTask(t.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
