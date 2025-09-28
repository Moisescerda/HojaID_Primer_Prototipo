import 'package:flutter/material.dart';

class DiagnosisHistoryScreen extends StatelessWidget {
  const DiagnosisHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Maíz', 'Gusano cogollero', '2025-03-12', 'Finca Norte'),
      ('Tomate', 'Tizón tardío', '2025-03-10', 'Parcela 7'),
      ('Trigo', 'Roya amarilla', '2025-03-08', 'Lote Este'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Historial de diagnósticos')),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, i) {
          final (cultivo, plaga, fecha, lugar) = items[i];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.bug_report_outlined),
              title: Text('$cultivo  •  $plaga',
                  style: const TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text('$lugar  •  $fecha'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Detalle de diagnóstico si lo necesitas
              },
            ),
          );
        },
      ),
    );
  }
}
