import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../data/task_store.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final store = CalendarStore.instance;

  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final chipBg = isLight ? const Color(0xFFF0F2F4) : Colors.white.withOpacity(0.08);

    return Scaffold(
      appBar: AppBar(title: const Text("Calendario")),
      body: AnimatedBuilder(
        animation: store,
        builder: (_, __) {
          final tasksToday = store.tasksOn(_selectedDay);
          final upcoming = store.allUpcoming(limit: 5);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // --- Calendario ---
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: TableCalendar<Task>(
                    firstDay: DateTime(2020),
                    lastDay: DateTime(2035),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) =>
                        day.year == _selectedDay.year &&
                        day.month == _selectedDay.month &&
                        day.day == _selectedDay.day,
                    calendarFormat: CalendarFormat.month,
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    headerStyle: const HeaderStyle(
                      titleCentered: true,
                      formatButtonVisible: false,
                    ),
                    eventLoader: (day) => store.tasksOn(day),
                    calendarStyle: CalendarStyle(
                      markerDecoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      markersAlignment: Alignment.bottomRight,
                      markersMaxCount: 3,
                    ),
                    onDaySelected: (selected, focused) {
                      setState(() {
                        _selectedDay = selected;
                        _focusedDay = focused;
                      });
                    },
                    onPageChanged: (focused) => _focusedDay = focused,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // --- Resumen de la fecha seleccionada ---
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(color: chipBg, borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Fecha seleccionada', style: TextStyle(fontSize: 12)),
                          const SizedBox(height: 4),
                          Text('${_selectedDay.day}/${_selectedDay.month}/${_selectedDay.year}',
                              style: const TextStyle(fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(color: chipBg, borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Próximas', style: TextStyle(fontSize: 12)),
                          const SizedBox(height: 4),
                          Text('${upcoming.length} recordatorios',
                              style: const TextStyle(fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              Text("Tareas de la fecha",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),

              if (tasksToday.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: const [
                        Icon(Icons.inbox_outlined),
                        SizedBox(width: 10),
                        Expanded(child: Text('Sin tareas en esta fecha.')),
                      ],
                    ),
                  ),
                )
              else
                ...tasksToday.map((t) => Card(
                      child: ListTile(
                        leading: Icon(t.done ? Icons.check_circle : Icons.radio_button_unchecked,
                            color: t.done ? Colors.green : null),
                        title: Text(t.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              decoration: t.done ? TextDecoration.lineThrough : null,
                            )),
                        subtitle: Text(
                            '${t.time.format(context)}${t.notes == null || t.notes!.isEmpty ? '' : ' • ${t.notes}'}'),
                        trailing: PopupMenuButton<String>(
                          onSelected: (v) {
                            switch (v) {
                              case 'toggle':
                                store.toggleDone(t.id);
                                break;
                              case 'delete':
                                store.removeTask(t.id);
                                break;
                            }
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(value: 'toggle', child: Text('Marcar/Desmarcar')),
                            PopupMenuItem(value: 'delete', child: Text('Eliminar')),
                          ],
                        ),
                        onTap: () => store.toggleDone(t.id),
                      ),
                    )),

              const SizedBox(height: 16),
              Text("Recordatorios próximos",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),

              ...upcoming.map((t) => Card(
                    child: ListTile(
                      leading: const Icon(Icons.notifications_active_outlined),
                      title: Text(t.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text(
                          '${t.date.day}/${t.date.month}/${t.date.year} • ${t.time.format(context)}${t.notes == null || t.notes!.isEmpty ? '' : ' • ${t.notes}'}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.check),
                        tooltip: 'Marcar hecho',
                        onPressed: () => store.toggleDone(t.id, value: true),
                      ),
                    ),
                  )),
              const SizedBox(height: 80),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddTaskSheet(context, _selectedDay),
        icon: const Icon(Icons.add),
        label: const Text('Nueva actividad'),
      ),
    );
  }

  Future<void> _openAddTaskSheet(BuildContext context, DateTime day) async {
    final titleCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    TimeOfDay selectedTime = const TimeOfDay(hour: 7, minute: 0);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
            top: 8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Nueva actividad',
                  style: Theme.of(ctx).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  prefixIcon: Icon(Icons.edit_outlined),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: notesCtrl,
                decoration: const InputDecoration(
                  labelText: 'Notas (opcional)',
                  prefixIcon: Icon(Icons.notes_outlined),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final t = await showTimePicker(context: ctx, initialTime: selectedTime);
                        if (t != null) {
                          selectedTime = t;
                          // Rebuild sheet
                          (ctx as Element).markNeedsBuild();
                        }
                      },
                      icon: const Icon(Icons.access_time),
                      label: Text('Hora: ${selectedTime.format(ctx)}'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (titleCtrl.text.trim().isEmpty) {
                      ScaffoldMessenger.of(ctx).showSnackBar(
                        const SnackBar(content: Text('Ingresa un título')),
                      );
                      return;
                    }
                    CalendarStore.instance.addTask(
                      day: day,
                      time: selectedTime,
                      title: titleCtrl.text.trim(),
                      notes: notesCtrl.text.trim().isEmpty ? null : notesCtrl.text.trim(),
                    );
                    Navigator.pop(ctx);
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('Guardar'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
