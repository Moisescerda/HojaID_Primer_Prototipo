import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reportes')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _ReportCard(
            icon: Icons.picture_as_pdf_outlined,
            title: 'Generar informe (PDF)',
            subtitle:
                'Crea un reporte con diagnósticos, tareas y recomendaciones.',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Generando PDF (demo)…')),
              );
            },
          ),
          _ReportCard(
            icon: Icons.table_chart_outlined,
            title: 'Exportar datos (CSV)',
            subtitle: 'Exporta para Excel/Sheets.',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Exportando CSV (demo)…')),
              );
            },
          ),
          _ReportCard(
            icon: Icons.share_outlined,
            title: 'Compartir reporte',
            subtitle: 'Envía por correo o apps.',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Compartir (demo)…')),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onPressed;

  const _ReportCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? const Color(0xFFF0F2F4)
                    : Colors.white.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 28,
                  color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text(subtitle),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: onPressed,
              child: const Text('Abrir'),
            ),
          ],
        ),
      ),
    );
  }
}
