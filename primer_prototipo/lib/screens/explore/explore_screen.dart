import 'package:flutter/material.dart';
import '../../Routes.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <_ExploreItem>[
      _ExploreItem(icon: Icons.eco, title: "Cultivos", subtitle: "Info de variedades"),
      _ExploreItem(icon: Icons.science, title: "Tratamientos", subtitle: "Plagas y enfermedades"),
      _ExploreItem(icon: Icons.cloud, title: "Clima", subtitle: "Pronósticos y alertas"),
      _ExploreItem(icon: Icons.map, title: "Mapa", subtitle: "Vista de parcelas"),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Exploración")),
      body: Column(
        children: [
          // Buscador
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Buscar recursos…",
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                // Altura fija suficiente para icono + título + subtítulo
                mainAxisExtent: 168,
              ),
              itemCount: items.length,
              itemBuilder: (_, i) {
                final it = items[i];
                return _ExploreCard(
                  icon: it.icon,
                  title: it.title,
                  subtitle: it.subtitle,
                  onTap: () {
                    switch (it.title) {
                      case "Cultivos":
                        Navigator.pushNamed(context, Routes.crops);
                        break;
                      case "Tratamientos":
                        Navigator.pushNamed(context, Routes.treatments);
                        break;
                      case "Clima":
                        Navigator.pushNamed(context, Routes.weather);
                        break;
                      case "Mapa":
                        Navigator.pushNamed(context, Routes.mapPlots);
                        break;
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ExploreItem {
  final IconData icon;
  final String title;
  final String subtitle;
  _ExploreItem({required this.icon, required this.title, required this.subtitle});
}

class _ExploreCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _ExploreCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final isLight = Theme.of(context).brightness == Brightness.light;

    final titleStyle = Theme.of(context)
        .textTheme
        .titleMedium
        ?.copyWith(fontWeight: FontWeight.w800);
    final subStyle = Theme.of(context)
        .textTheme
        .bodySmall
        ?.copyWith(color: isLight ? Colors.black54 : Colors.white70);

    final bubbleColor =
        isLight ? const Color(0xFFF0F2F4) : Colors.white.withOpacity(0.08);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icono dentro de “burbuja”
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: bubbleColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 28, color: primary),
              ),
              const SizedBox(height: 12),
              Text(title, textAlign: TextAlign.center, style: titleStyle),
              const SizedBox(height: 6),
              // Subtítulo visible y sin overflow
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: subStyle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
