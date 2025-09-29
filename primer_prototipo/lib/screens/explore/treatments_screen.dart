import 'package:flutter/material.dart';

class TreatmentsScreen extends StatefulWidget {
  const TreatmentsScreen({Key? key}) : super(key: key);

  @override
  State<TreatmentsScreen> createState() => _TreatmentsScreenState();
}

class _TreatmentsScreenState extends State<TreatmentsScreen> {
  String _filter = 'Todos';

  final items = <_TreatmentRec>[
    _TreatmentRec(crop: 'Maíz', issue: 'Gusano cogollero', severity: 'Alta',
        actions: ['Aplicar Bacillus thuringiensis', 'Monitoreo cada 48h', 'Rotación de ingredientes activos']),
    _TreatmentRec(crop: 'Tomate', issue: 'Tizón tardío', severity: 'Media',
        actions: ['Fungicida preventivo (cobre)', 'Mejorar ventilación', 'Retirar hojas enfermas']),
    _TreatmentRec(crop: 'Frijol', issue: 'Mildiu', severity: 'Baja',
        actions: ['Fungicida ligero', 'Evitar riego por aspersión']),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _filter == 'Todos' ? items : items.where((e) => e.crop == _filter).toList();
    final crops = ['Todos', ...{for (var i in items) i.crop}];

    return Scaffold(
      appBar: AppBar(title: const Text('Tratamientos')),
      body: Column(
        children: [
          // Filtro por cultivo
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: DropdownButtonFormField<String>(
              value: _filter,
              decoration: const InputDecoration(
                labelText: 'Filtrar por cultivo',
                prefixIcon: Icon(Icons.filter_list),
              ),
              items: crops.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _filter = v ?? 'Todos'),
            ),
          ),
          const SizedBox(height: 8),

          // Lista
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final t = filtered[i];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${t.crop} • ${t.issue}',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.warning_amber_outlined, size: 18),
                            const SizedBox(width: 6),
                            Text('Severidad: ${t.severity}'),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ...t.actions.map((a) => Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.check_circle_outline, size: 18),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(a)),
                                ],
                              ),
                            )),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // Aquí podrías enlazar con la foto/diagnóstico más reciente
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Aplicar tratamiento (demo)')),
                              );
                            },
                            icon: const Icon(Icons.playlist_add_check),
                            label: const Text('Aplicar'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TreatmentRec {
  final String crop;
  final String issue;
  final String severity;
  final List<String> actions;
  _TreatmentRec({required this.crop, required this.issue, required this.severity, required this.actions});
}
