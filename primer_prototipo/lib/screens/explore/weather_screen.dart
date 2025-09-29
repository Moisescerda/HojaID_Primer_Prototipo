import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Position? _pos;
  bool _loading = false;

  // Datos mock (conecta tu API de clima aquí)
  double? temperatureC = 28.0;
  int? humidity = 65;
  int? rainChance = 40;
  String advice = 'Buen momento para riego ligero; posponer siembra si lluvia > 50%.';

  @override
  void initState() {
    super.initState();
    _requestLocation();
  }

  Future<void> _requestLocation() async {
    setState(() => _loading = true);

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _snack('Activa el GPS para obtener el clima local.');
      setState(() => _loading = false);
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
      _snack('Permiso de ubicación denegado.');
      setState(() => _loading = false);
      return;
    }

    try {
      final p = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() => _pos = p);
      // TODO: Llama a tu API de clima con p.latitude / p.longitude y actualiza: temperatureC, humidity, rainChance, advice
    } catch (_) {
      _snack('No se pudo obtener la ubicación.');
    } finally {
      setState(() => _loading = false);
    }
  }

  void _snack(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final chipBg = isLight ? const Color(0xFFF0F2F4) : Colors.white.withOpacity(0.08);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clima'),
        actions: [
          IconButton(onPressed: _loading ? null : _requestLocation, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Cabecera tipo “Google Weather”
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_pos == null
                            ? 'Ubicación no disponible'
                            : 'Ubicación: ${_pos!.latitude.toStringAsFixed(4)}, ${_pos!.longitude.toStringAsFixed(4)}'),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(temperatureC != null ? '${temperatureC!.toStringAsFixed(0)}°' : '—°',
                                style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w900)),
                            const SizedBox(width: 12),
                            Text('Humedad: ${humidity ?? '-'}% • Lluvia: ${rainChance ?? '-'}%'),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _chip(context, chipBg, Icons.thermostat, 'Temp', '${temperatureC ?? '-'} °C'),
                            _chip(context, chipBg, Icons.water_drop_outlined, 'Humedad', '${humidity ?? '-'} %'),
                            _chip(context, chipBg, Icons.umbrella_outlined, 'Lluvia', '${rainChance ?? '-'} %'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                // Histórico y pronóstico simple (mock)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Evolución reciente y pronóstico',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 10),
                        _miniForecastRow(context, [
                          ('Ayer', '27°', '20%'),
                          ('Hoy', '28°', '40%'),
                          ('Mañana', '29°', '30%'),
                          ('+2 días', '30°', '20%'),
                        ]),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                // Consejos de labores
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.agriculture),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Consejos agronómicos',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                              const SizedBox(height: 6),
                              Text(advice),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _chip(BuildContext context, Color bg, IconData ic, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(24)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(ic, size: 18),
          const SizedBox(width: 6),
          Text('$label: $value'),
        ],
      ),
    );
  }

  Widget _miniForecastRow(BuildContext context, List<(String, String, String)> data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: data.map((d) {
        final (day, t, r) = d;
        return Column(
          children: [
            Text(day, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            Text(t, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text(r, style: const TextStyle(fontSize: 12)),
          ],
        );
      }).toList(),
    );
  }
}
