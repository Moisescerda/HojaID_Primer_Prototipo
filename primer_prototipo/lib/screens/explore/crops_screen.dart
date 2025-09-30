import 'package:flutter/material.dart';

class CropsScreen extends StatefulWidget {
  const CropsScreen({Key? key}) : super(key: key);

  @override
  State<CropsScreen> createState() => _CropsScreenState();
}

class _CropsScreenState extends State<CropsScreen> {
  String _beanFilter = 'Todos';

  final List<_BeanCrop> _all = [
    _BeanCrop(
      beanType: 'Frijol negro',
      stage: 'Floración',
      progress: 0.52,
      expectedYieldTons: 2.8,
      potentialLoss: 0.10,
      areaHa: 1.6,
    ),
    _BeanCrop(
      beanType: 'Frijol rojo',
      stage: 'Llenado de vainas',
      progress: 0.74,
      expectedYieldTons: 3.1,
      potentialLoss: 0.07,
      areaHa: 1.2,
    ),
    _BeanCrop(
      beanType: 'Frijol criollo',
      stage: 'Crecimiento vegetativo',
      progress: 0.35,
      expectedYieldTons: 2.4,
      potentialLoss: 0.05,
      areaHa: 0.9,
    ),
    _BeanCrop(
      beanType: 'Frijol empacado',
      stage: 'Postcosecha / Almacenado',
      progress: 1.00,
      expectedYieldTons: 2.7,
      potentialLoss: 0.03,
      areaHa: 0.0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _beanFilter == 'Todos'
        ? _all
        : _all.where((e) => e.beanType == _beanFilter).toList();
    final beans = <String>{'Todos', ..._all.map((e) => e.beanType)};

    return Scaffold(
      appBar: AppBar(title: const Text('Cultivos — Frijol')),
      body: Column(
        children: [
          // Filtro por tipo de frijol
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: DropdownButtonFormField<String>(
              value: _beanFilter,
              decoration: const InputDecoration(
                labelText: 'Tipo de frijol',
                prefixIcon: Icon(Icons.spa_outlined),
              ),
              items: beans
                  .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                  .toList(),
              onChanged: (v) => setState(() => _beanFilter = v ?? 'Todos'),
            ),
          ),
          const SizedBox(height: 8),

          // Lista
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) => _BeanCard(
                data: filtered[i],
                onTap: () => _showDetails(context, filtered[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDetails(BuildContext ctx, _BeanCrop c) {
    showModalBottomSheet(
      context: ctx,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(c.beanType,
                  style: Theme.of(ctx)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              Text('Etapa actual: ${c.stage}'),
              if (c.areaHa > 0) Text('Área estimada: ${c.areaHa.toStringAsFixed(2)} ha'),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(value: c.progress, minHeight: 10),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _miniStat(
                      'Desarrollo',
                      '${(c.progress * 100).toStringAsFixed(0)}%',
                    ),
                  ),
                  Expanded(
                    child: _miniStat(
                      'Producción',
                      '${c.expectedYieldTons.toStringAsFixed(1)} t',
                    ),
                  ),
                  Expanded(
                    child: _miniStat(
                      'Pos. pérdida',
                      '${(c.potentialLoss * 100).toStringAsFixed(0)}%',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
                        content: Text('Abrir monitoreo/diagnóstico (demo)'),
                      ));
                    },
                    icon: const Icon(Icons.camera_alt_outlined),
                    label: const Text('Monitorear'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
                        content: Text('Ver tratamientos sugeridos (demo)'),
                      ));
                    },
                    icon: const Icon(Icons.medication_outlined),
                    label: const Text('Tratamientos'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* -------------------- Widgets auxiliares -------------------- */

class _BeanCard extends StatelessWidget {
  final _BeanCrop data;
  final VoidCallback onTap;
  const _BeanCard({required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bubble = Theme.of(context).brightness == Brightness.light
        ? const Color(0xFFF0F2F4)
        : Colors.white.withValues(alpha: .08);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Badge
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: bubble, shape: BoxShape.circle),
                child: const Icon(Icons.eco, size: 26),
              ),
              const SizedBox(width: 12),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.beanType,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text('Etapa: ${data.stage}'),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: data.progress,
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: _miniStat(
                            'Desarrollo',
                            '${(data.progress * 100).toStringAsFixed(0)}%',
                          ),
                        ),
                        Expanded(
                          child: _miniStat(
                            'Producción',
                            '${data.expectedYieldTons.toStringAsFixed(1)} t',
                          ),
                        ),
                        Expanded(
                          child: _miniStat(
                            'Pos. pérdida',
                            '${(data.potentialLoss * 100).toStringAsFixed(0)}%',
                          ),
                        ),
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
  }
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

/* ------------------------- Modelo ------------------------- */

class _BeanCrop {
  final String beanType; // Negro | Rojo | Criollo | Empacado
  final String stage;
  final double progress; // 0..1
  final double expectedYieldTons;
  final double potentialLoss; // 0..1
  final double areaHa;

  _BeanCrop({
    required this.beanType,
    required this.stage,
    required this.progress,
    required this.expectedYieldTons,
    required this.potentialLoss,
    this.areaHa = 0,
  });
}
