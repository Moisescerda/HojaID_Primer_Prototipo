import 'package:flutter/material.dart';

class TreatmentsScreen extends StatefulWidget {
  const TreatmentsScreen({Key? key}) : super(key: key);

  @override
  State<TreatmentsScreen> createState() => _TreatmentsScreenState();
}

class _TreatmentsScreenState extends State<TreatmentsScreen> {
  // Filtros
  String _beanFilter = 'Todos';
  String _issueFilter = 'Todos';

  // Catálogos
  final List<String> beans = const [
    'Todos',
    'Frijol negro',
    'Frijol rojo',
    'Frijol criollo',
    'Frijol empacado',
  ];

  final List<String> issues = const [
    'Todos',
    'Enfermedad',
    'Plaga',
  ];

  // Base de recomendaciones (demo)
  late final List<_TreatmentRec> _all = [
    _TreatmentRec(
      bean: 'Frijol negro',
      issueType: 'Enfermedad',
      issueName: 'Roya',
      scientificName: 'Uromyces appendiculatus',
      severity: 'Alta',
      actions: const [
        'Aplicar fungicida triazol (propiconazol/tebuconazol) según etiqueta.',
        'Alternar con cúpricos para manejo de resistencia.',
        'Retirar hojas muy afectadas y mejorar ventilación del cultivo.',
        'Evitar riego por aspersión en la tarde.',
      ],
    ),
    _TreatmentRec(
      bean: 'Frijol negro',
      issueType: 'Plaga',
      issueName: 'Mosca blanca',
      scientificName: 'Bemisia tabaci',
      severity: 'Media',
      actions: const [
        'Monitoreo con trampas amarillas: 10–20 por ha.',
        'Aplicar aceite mineral o jabón potásico (control suave) en focos.',
        'Rotar ingredientes activos (p.ej. imidacloprid, spirotetramat) según etiqueta.',
      ],
    ),
    _TreatmentRec(
      bean: 'Frijol rojo',
      issueType: 'Enfermedad',
      issueName: 'Mildiu',
      scientificName: 'Peronospora spp.',
      severity: 'Media',
      actions: const [
        'Fungicida preventivo a base de cobre o fosfitos.',
        'Mejorar ventilación y evitar exceso de humedad en el follaje.',
        'Riego temprano en la mañana.',
      ],
    ),
    _TreatmentRec(
      bean: 'Frijol criollo',
      issueType: 'Plaga',
      issueName: 'Trips',
      scientificName: 'Frankliniella spp.',
      severity: 'Baja',
      actions: const [
        'Monitorear con tarjetas azules.',
        'Aplicar extractos botánicos o spinosad en focos (según etiqueta).',
        'Eliminar malezas hospederas alrededor del lote.',
      ],
    ),
    _TreatmentRec(
      bean: 'Frijol empacado',
      issueType: 'Enfermedad',
      issueName: 'Antracnosis',
      scientificName: 'Colletotrichum lindemuthianum',
      severity: 'Alta',
      actions: const [
        'Semilla certificada o tratada (thiram/carbendazim, según etiqueta).',
        'Aplicaciones de contacto + sistémicos en aparición temprana.',
        'Evitar labores cuando haya humedad en plantas.',
      ],
    ),
    _TreatmentRec(
      bean: 'Frijol empacado',
      issueType: 'Plaga',
      issueName: 'Pulgones',
      scientificName: 'Aphis craccivora',
      severity: 'Media',
      actions: const [
        'Conservar enemigos naturales (mariquitas/parasitoides).',
        'Aceites o jabón potásico para reducción inicial.',
        'Rotar insecticidas selectivos si la presión es alta (según etiqueta).',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Filtrado
    final List<_TreatmentRec> filtered = _all.where((t) {
      final byBean = _beanFilter == 'Todos' || t.bean == _beanFilter;
      final byIssue = _issueFilter == 'Todos' || t.issueType == _issueFilter;
      return byBean && byIssue;
    }).toList();

    final isLight = Theme.of(context).brightness == Brightness.light;
    final subColor = isLight ? Colors.black54 : Colors.white70;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tratamientos — Frijol'),
      ),
      body: Column(
        children: [
          // ====== Filtros responsivos (sin overflow) ======
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: LayoutBuilder(
              builder: (context, c) {
                // Dos columnas si hay espacio, si no se apilan (Wrap)
                final double colW = (c.maxWidth - 12) / 2;
                return Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    SizedBox(
                      width: colW,
                      child: _ChipDropdown<String>(
                        value: _beanFilter,
                        label: 'Tipo de frijol',
                        icon: Icons.spa_outlined,
                        items: beans
                            .map((b) => DropdownMenuItem(
                                  value: b,
                                  child: Text(b, overflow: TextOverflow.ellipsis),
                                ))
                            .toList(),
                        onChanged: (v) => setState(() => _beanFilter = v ?? 'Todos'),
                      ),
                    ),
                    SizedBox(
                      width: colW,
                      child: _ChipDropdown<String>(
                        value: _issueFilter,
                        label: 'Problema',
                        icon: Icons.bug_report_outlined,
                        items: issues
                            .map((p) => DropdownMenuItem(
                                  value: p,
                                  child: Text(p, overflow: TextOverflow.ellipsis),
                                ))
                            .toList(),
                        onChanged: (v) => setState(() => _issueFilter = v ?? 'Todos'),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // ====== Lista ======
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
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
                        // Título + chip de severidad
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                '${t.bean} • ${t.issueName}'
                                '${t.scientificName != null ? ' (${t.scientificName})' : ''}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w900),
                              ),
                            ),
                            const SizedBox(width: 8),
                            _severityChip(t.severity),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Tipo de problema
                        Row(
                          children: [
                            const Icon(Icons.settings_backup_restore_outlined, size: 18),
                            const SizedBox(width: 6),
                            Text(t.issueType, style: TextStyle(color: subColor)),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Acciones
                        ...t.actions.map(
                          (a) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.check_circle_outline, size: 18),
                                const SizedBox(width: 8),
                                Expanded(child: Text(a)),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Botón aplicar (demo)
                        Align(
                          alignment: Alignment.centerRight,
                          child: OutlinedButton.icon(
                            onPressed: () {
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

  // Chip de severidad con color
  Widget _severityChip(String severity) {
    Color bg;
    Color fg;
    switch (severity) {
      case 'Alta':
        bg = const Color(0xFFB3261E).withValues(alpha: .18);
        fg = const Color(0xFFE66B65);
        break;
      case 'Media':
        bg = const Color(0xFF7A4F01).withValues(alpha: .18);
        fg = const Color(0xFFE6B25C);
        break;
      default:
        bg = const Color(0xFF0B4F2E).withValues(alpha: .18);
        fg = const Color(0xFF6CD49C);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: fg.withValues(alpha: .45)),
      ),
      child: Text(
        'Severidad: $severity',
        style: TextStyle(color: fg, fontWeight: FontWeight.w800, letterSpacing: .2),
      ),
    );
  }
}

/* ========= Helper: Dropdown con estilo chip/compacto ========= */

class _ChipDropdown<T> extends StatelessWidget {
  final T? value;
  final String label;
  final IconData icon;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;

  const _ChipDropdown({
    required this.value,
    required this.label,
    required this.icon,
    required this.items,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(28);
    return DropdownButtonFormField<T>(
      value: value,
      isDense: true,
      isExpanded: true, // ← evita overflow y usa el ancho disponible
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        prefixIconConstraints: const BoxConstraints(minWidth: 40),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(borderRadius: radius),
        enabledBorder: OutlineInputBorder(borderRadius: radius),
        focusedBorder: OutlineInputBorder(borderRadius: radius),
        filled: true,
        fillColor: Theme.of(context).brightness == Brightness.light
            ? const Color(0xFFF7F8FA)
            : Colors.white.withValues(alpha: .06),
      ),
      items: items,
      onChanged: onChanged,
    );
  }
}

/* ======================= Modelo ======================= */

class _TreatmentRec {
  final String bean; // Frijol negro/rojo/criollo/empacado
  final String issueType; // Enfermedad / Plaga
  final String issueName; // Roya, Mildiu, etc.
  final String? scientificName; // opcional
  final String severity; // Alta / Media / Baja
  final List<String> actions;

  _TreatmentRec({
    required this.bean,
    required this.issueType,
    required this.issueName,
    this.scientificName,
    required this.severity,
    required this.actions,
  });
}
