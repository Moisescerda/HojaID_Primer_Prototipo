import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class MapPlotsScreen extends StatefulWidget {
  const MapPlotsScreen({Key? key}) : super(key: key);

  @override
  State<MapPlotsScreen> createState() => _MapPlotsScreenState();
}

class _MapPlotsScreenState extends State<MapPlotsScreen> with SingleTickerProviderStateMixin {
  late final TabController _tab;

  // --- Manual ---
  double _sizeHa = 1.0; // tamaño del terreno en hectáreas
  int _zones = 4;
  final List<_ZoneAffect> _affects = []; // se llenará por zona

  // --- Caminando ---
  bool _recording = false;
  final List<Position> _track = [];

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    _generateAffects();
  }

  void _generateAffects() {
    _affects
      ..clear()
      ..addAll(List.generate(_zones, (i) => _ZoneAffect(zone: i + 1)));
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  // ----------------- Walk mode helpers -----------------
  Future<void> _toggleRecord() async {
    if (_recording) {
      setState(() => _recording = false);
      return;
    }
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
      _snack('Activa el GPS para registrar el terreno.');
      return;
    }
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) perm = await Geolocator.requestPermission();
    if (perm == LocationPermission.denied || perm == LocationPermission.deniedForever) {
      _snack('Permiso de ubicación denegado.');
      return;
    }

    _track.clear();
    setState(() => _recording = true);

    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 2),
    ).listen((pos) {
      if (!_recording) return;
      setState(() => _track.add(pos));
    });
  }

  double _estimateAreaM2FromTrack(List<Position> pts) {
    // Aproximación: convierte lat/lon a metros (proyección equirectangular simple)
    if (pts.length < 3) return 0;
    final mpts = <Offset>[];
    final lat0 = pts.first.latitude * math.pi / 180.0;
    const R = 6371000.0;
    for (final p in pts) {
      final lat = p.latitude * math.pi / 180.0;
      final lon = p.longitude * math.pi / 180.0;
      final x = R * (lon - pts.first.longitude * math.pi / 180.0) * math.cos(lat0);
      final y = R * (lat - lat0);
      mpts.add(Offset(x.toDouble(), y.toDouble()));
    }
    // Cierra polígono
    final poly = List<Offset>.from(mpts);
    if (poly.first != poly.last) poly.add(poly.first);

    // Área por fórmula del “cordón” (shoelace)
    double area = 0;
    for (var i = 0; i < poly.length - 1; i++) {
      area += poly[i].dx * poly[i + 1].dy - poly[i + 1].dx * poly[i].dy;
    }
    return area.abs() / 2.0;
  }

  void _snack(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  // ----------------- UI -----------------
  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final chipBg = isLight ? const Color(0xFFF0F2F4) : Colors.white.withOpacity(0.08);

    final areaWalkM2 = _estimateAreaM2FromTrack(_track);
    final areaWalkHa = areaWalkM2 / 10_000.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa del terreno'),
        bottom: TabBar(
          controller: _tab,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.tune), text: 'Manual'),
            Tab(icon: Icon(Icons.directions_walk), text: 'Caminando'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          // =========== MANUAL ===========
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Resumen superior
              Row(
                children: [
                  Expanded(child: _summaryBox('Tamaño (ha)', _sizeHa.toStringAsFixed(2), chipBg)),
                  const SizedBox(width: 8),
                  Expanded(child: _summaryBox('Zonas', '$_zones', chipBg)),
                ],
              ),
              const SizedBox(height: 12),

              // Controles
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Parámetros', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: _sizeHa.toStringAsFixed(2),
                              decoration: const InputDecoration(labelText: 'Tamaño (ha)', prefixIcon: Icon(Icons.square_foot)),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              onChanged: (v) {
                                final d = double.tryParse(v.replaceAll(',', '.'));
                                if (d != null && d > 0) setState(() => _sizeHa = d);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              initialValue: _zones.toString(),
                              decoration: const InputDecoration(labelText: 'Zonas', prefixIcon: Icon(Icons.grid_view)),
                              keyboardType: TextInputType.number,
                              onChanged: (v) {
                                final n = int.tryParse(v);
                                if (n != null && n > 0 && n <= 24) {
                                  setState(() {
                                    _zones = n;
                                    _generateAffects();
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Dibujo del “mapa” (placeholder dividido en zonas)
              SizedBox(
                height: 260,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: CustomPaint(
                      painter: _ManualPlotPainter(zones: _zones),
                      child: const SizedBox.expand(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Afectaciones por zona
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Afectaciones por zona',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 8),
                      ..._affects.map((z) => _zoneTile(context, z)).toList(),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: FilledButton.icon(
                          onPressed: () {
                            // Redirigir a tratamientos
                            // Navigator.pushNamed(context, Routes.recommendations);
                            _snack('Redirigiendo a tratamientos (demo)');
                          },
                          icon: const Icon(Icons.fact_check_outlined),
                          label: const Text('Ver tratamientos'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // =========== CAMINANDO ===========
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Resumen
              Row(
                children: [
                  Expanded(child: _summaryBox('Puntos', '${_track.length}', chipBg)),
                  const SizedBox(width: 8),
                  Expanded(child: _summaryBox('Área aprox. (ha)', areaWalkHa.toStringAsFixed(3), chipBg)),
                ],
              ),
              const SizedBox(height: 12),

              // Controles de grabación
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(_recording ? 'Grabando recorrido...' : 'Listo para grabar',
                            style: const TextStyle(fontWeight: FontWeight.w700)),
                      ),
                      FilledButton.icon(
                        onPressed: _toggleRecord,
                        icon: Icon(_recording ? Icons.stop : Icons.fiber_manual_record),
                        label: Text(_recording ? 'Detener' : 'Iniciar'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Vista del trazo
              SizedBox(
                height: 260,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: CustomPaint(
                      painter: _WalkPlotPainter(track: _track),
                      child: const SizedBox.expand(),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),
              Text('Consejo: camina bordeando el terreno lentamente para capturar puntos limpios. '
                  'Al finalizar, podrás dividirlo en zonas (próximo paso).'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryBox(String label, String value, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  Widget _zoneTile(BuildContext context, _ZoneAffect z) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(child: Text('${z.zone}')),
      title: TextFormField(
        initialValue: z.description,
        decoration: const InputDecoration(labelText: 'Descripción breve'),
        onChanged: (v) => z.description = v,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 6),
          Text('Porcentaje de daño: ${z.damage.toStringAsFixed(0)}%'),
          Slider(
            value: z.damage,
            min: 0,
            max: 100,
            divisions: 20,
            label: '${z.damage.toStringAsFixed(0)}%',
            onChanged: (v) => setState(() => z.damage = v),
          ),
        ],
      ),
    );
  }
}

class _ZoneAffect {
  final int zone;
  double damage = 0; // %
  String description = '';
  _ZoneAffect({required this.zone});
}

class _ManualPlotPainter extends CustomPainter {
  final int zones;
  _ManualPlotPainter({required this.zones});

  @override
  void paint(Canvas canvas, Size size) {
    final r = RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(12));
    final border = Paint()
      ..color = Colors.grey.shade500
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final fill = Paint()
      ..color = Colors.grey.withOpacity(0.08)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(r, fill);
    canvas.drawRRect(r, border);

    // Divide en una cuadrícula “razonable”
    final cols = (math.sqrt(zones)).ceil();
    final rows = (zones / cols).ceil();
    final cellW = size.width / cols;
    final cellH = size.height / rows;

    final grid = Paint()
      ..color = Colors.grey.shade400
      ..style = PaintingStyle.stroke;

    for (int c = 1; c < cols; c++) {
      final x = c * cellW;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (int rIdx = 1; rIdx < rows; rIdx++) {
      final y = rIdx * cellH;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
  }

  @override
  bool shouldRepaint(covariant _ManualPlotPainter old) => old.zones != zones;
}

class _WalkPlotPainter extends CustomPainter {
  final List<Position> track;
  _WalkPlotPainter({required this.track});

  @override
  void paint(Canvas canvas, Size size) {
    // Si no hay puntos, dibuja marco
    final rect = RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(12));
    final border = Paint()
      ..color = Colors.grey.shade500
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final fill = Paint()
      ..color = Colors.grey.withOpacity(0.08)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(rect, fill);
    canvas.drawRRect(rect, border);

    if (track.length < 2) return;

    // Normaliza puntos a la caja
    final latitudes = track.map((e) => e.latitude).toList();
    final longitudes = track.map((e) => e.longitude).toList();
    final minLat = latitudes.reduce(math.min);
    final maxLat = latitudes.reduce(math.max);
    final minLon = longitudes.reduce(math.min);
    final maxLon = longitudes.reduce(math.max);

    final w = maxLon - minLon;
    final h = maxLat - minLat;
    final pad = 16.0;

    Offset toCanvas(double lat, double lon) {
      final x = (lon - minLon) / (w == 0 ? 1 : w) * (size.width - 2 * pad) + pad;
      final y = (1 - (lat - minLat) / (h == 0 ? 1 : h)) * (size.height - 2 * pad) + pad;
      return Offset(x, y);
    }

    final path = Path()..moveTo(toCanvas(track.first.latitude, track.first.longitude).dx,
        toCanvas(track.first.latitude, track.first.longitude).dy);
    for (int i = 1; i < track.length; i++) {
      final p = toCanvas(track[i].latitude, track[i].longitude);
      path.lineTo(p.dx, p.dy);
    }

    final paintPath = Paint()
      ..color = Colors.greenAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawPath(path, paintPath);
  }

  @override
  bool shouldRepaint(covariant _WalkPlotPainter old) => old.track.length != track.length;
}
