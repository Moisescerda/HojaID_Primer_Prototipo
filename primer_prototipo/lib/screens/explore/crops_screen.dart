import 'package:flutter/material.dart';

class CropsScreen extends StatelessWidget {
  const CropsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final crops = <_Crop>[
      _Crop(name: 'Maíz', stage: 'Crecimiento vegetativo', progress: 0.62, expectedYieldTons: 7.2, potentialLoss: 0.10),
      _Crop(name: 'Tomate', stage: 'Floración', progress: 0.48, expectedYieldTons: 4.1, potentialLoss: 0.05),
      _Crop(name: 'Frijol', stage: 'Maduración', progress: 0.85, expectedYieldTons: 2.9, potentialLoss: 0.03),
      _Crop(name: 'Trigo', stage: 'Siembra', progress: 0.08, expectedYieldTons: 5.0, potentialLoss: 0.00),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Cultivos')),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: crops.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, i) {
          final c = crops[i];
          return Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => _showDetails(context, c),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    // “badge” del cultivo
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.light
                            ? const Color(0xFFF0F2F4) : Colors.white.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.eco, size: 26),
                    ),
                    const SizedBox(width: 12),
                    // info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c.name,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                          const SizedBox(height: 4),
                          Text('Etapa: ${c.stage}'),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(value: c.progress, minHeight: 8),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(child: _miniStat('Desarrollo', '${(c.progress * 100).toStringAsFixed(0)}%')),
                              Expanded(child: _miniStat('Producción', '${c.expectedYieldTons.toStringAsFixed(1)} t')),
                              Expanded(child: _miniStat('Pos. pérdida', '${(c.potentialLoss * 100).toStringAsFixed(0)}%')),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _miniStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
      ],
    );
  }

  void _showDetails(BuildContext ctx, _Crop c) {
    showModalBottomSheet(
      context: ctx,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(c.name, style: Theme.of(ctx).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text('Etapa actual: ${c.stage}'),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(value: c.progress, minHeight: 10),
            ),
            const SizedBox(height: 12),
            Text('Producción estimada: ${c.expectedYieldTons.toStringAsFixed(1)} t'),
            Text('Posible pérdida: ${(c.potentialLoss * 100).toStringAsFixed(0)}%'),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {
                Navigator.pop(ctx);
                // Podrías navegar a recomendaciones filtradas por este cultivo
                // Navigator.pushNamed(ctx, Routes.recommendations);
              },
              icon: const Icon(Icons.fact_check_outlined),
              label: const Text('Ver recomendaciones'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Crop {
  final String name;
  final String stage;
  final double progress; // 0..1
  final double expectedYieldTons;
  final double potentialLoss; // 0..1
  _Crop({
    required this.name,
    required this.stage,
    required this.progress,
    required this.expectedYieldTons,
    required this.potentialLoss,
  });
}
