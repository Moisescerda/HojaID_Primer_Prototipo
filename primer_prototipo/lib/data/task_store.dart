import 'package:flutter/material.dart';

/// Modelo de tarea/actividad
class Task {
  final String id;
  final DateTime date; // solo la fecha (sin hora)
  final TimeOfDay time; // hora del día
  final String title;
  final String? notes;
  bool done;

  Task({
    required this.id,
    required this.date,
    required this.time,
    required this.title,
    this.notes,
    this.done = false,
  });

  DateTime get dateTime =>
      DateTime(date.year, date.month, date.day, time.hour, time.minute);
}

/// Almacén simple en memoria (singleton) para compartir entre pantallas.
class CalendarStore extends ChangeNotifier {
  CalendarStore._internal();
  static final CalendarStore instance = CalendarStore._internal();

  // clave: 'yyyy-mm-dd'
  final Map<String, List<Task>> _byDay = {};

  static String _keyForDay(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  List<Task> tasksOn(DateTime day) {
    final k = _keyForDay(day);
    final list = List<Task>.from(_byDay[k] ?? const []);
    list.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return list;
  }

  List<Task> allUpcoming({int? limit}) {
    final now = DateTime.now();
    final all = _byDay.values.expand((e) => e).where((t) => t.dateTime.isAfter(now)).toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
    if (limit != null && all.length > limit) return all.take(limit).toList();
    return all;
  }

  void addTask({
    required DateTime day,
    required TimeOfDay time,
    required String title,
    String? notes,
  }) {
    final k = _keyForDay(day);
    final t = Task(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      date: DateTime(day.year, day.month, day.day),
      time: time,
      title: title,
      notes: notes,
    );
    _byDay.putIfAbsent(k, () => []);
    _byDay[k]!.add(t);
    notifyListeners();
  }

  void toggleDone(String id, {bool? value}) {
    for (final list in _byDay.values) {
      for (final t in list) {
        if (t.id == id) {
          t.done = value ?? !t.done;
          notifyListeners();
          return;
        }
      }
    }
  }

  void removeTask(String id) {
    for (final entry in _byDay.entries) {
      entry.value.removeWhere((t) => t.id == id);
    }
    notifyListeners();
  }
}
