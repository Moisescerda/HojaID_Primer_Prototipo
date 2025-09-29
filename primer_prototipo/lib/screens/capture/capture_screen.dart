import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../Routes.dart';

class CaptureScreen extends StatefulWidget {
  const CaptureScreen({Key? key}) : super(key: key);

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  final ImagePicker _picker = ImagePicker();

  // Barra inferior tipo Gemini
  final TextEditingController _barCtrl = TextEditingController();

  XFile? _image;
  bool _busy = false;

  @override
  void dispose() {
    _barCtrl.dispose();
    super.dispose();
  }

  // ========================= permisos =========================
  Future<bool> _ensureCameraPermission() async {
    final status = await Permission.camera.status;
    if (status.isGranted) return true;

    final req = await Permission.camera.request();
    if (req.isGranted) return true;

    if (req.isPermanentlyDenied) {
      _showOpenSettings('cámara');
    } else {
      _showSnack('Permiso de cámara denegado.');
    }
    return false;
  }

  Future<bool> _ensurePhotosPermission() async {
    if (Platform.isIOS) {
      final st = await Permission.photos.status;
      if (st.isGranted) return true;
      final req = await Permission.photos.request();
      if (req.isGranted) return true;
      if (req.isPermanentlyDenied) {
        _showOpenSettings('fotos');
      } else {
        _showSnack('Permiso para fotos denegado.');
      }
      return false;
    } else {
      var stPhotos = await Permission.photos.status;
      var stStorage = await Permission.storage.status;
      if (stPhotos.isGranted || stStorage.isGranted) return true;

      final reqPhotos = await Permission.photos.request();
      if (reqPhotos.isGranted) return true;

      final reqStorage = await Permission.storage.request();
      if (reqStorage.isGranted) return true;

      if (reqPhotos.isPermanentlyDenied || reqStorage.isPermanentlyDenied) {
        _showOpenSettings('galería');
      } else {
        _showSnack('Permiso para galería denegado.');
      }
      return false;
    }
  }

  // ========================= acciones =========================
  Future<void> _pickFromCamera() async {
    if (!await _ensureCameraPermission()) return;
    setState(() => _busy = true);
    try {
      final img = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1600,
        imageQuality: 90,
      );
      if (img != null) setState(() => _image = img);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _pickFromGallery() async {
    if (!await _ensurePhotosPermission()) return;
    setState(() => _busy = true);
    try {
      final img = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
        imageQuality: 90,
      );
      if (img != null) setState(() => _image = img);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _showOpenSettings(String cual) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Permiso requerido'),
        content: Text('Para continuar necesitamos el permiso de $cual. ¿Abrir ajustes de la app?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Abrir ajustes')),
        ],
      ),
    );
    if (ok == true) {
      await openAppSettings();
    }
  }

  // ================== Calculadora (frijol) ==================
  void _openCalculator() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) => _BeanCalcSheet(onDone: (res) {
        Navigator.pop(ctx);
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(res.title),
            content: Text(res.details),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar')),
            ],
          ),
        );
      }),
    );
  }

  // Panel “+” (acciones rápidas) — compacto
  void _openPlusOptions() {
    final isLight = Theme.of(context).brightness == Brightness.light;
    showModalBottomSheet(
      context: context,
      backgroundColor: isLight ? Colors.white : const Color(0xFF121212),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SizedBox(
        height: 120, // compacto
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _QuickAction(
                label: 'Cámara',
                icon: Icons.photo_camera_outlined,
                onTap: () {
                  Navigator.pop(context);
                  _pickFromCamera();
                },
              ),
              _QuickAction(
                label: 'Galería',
                icon: Icons.photo_outlined,
                onTap: () {
                  Navigator.pop(context);
                  _pickFromGallery();
                },
              ),
              _QuickAction(
                label: 'Calculadora',
                icon: Icons.calculate_outlined,
                onTap: () {
                  Navigator.pop(context);
                  _openCalculator();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Enviar desde la barra inferior
  void _onSendFromBar() {
    final text = _barCtrl.text.trim();
    if (text.isEmpty) {
      _showSnack('Escribe una breve descripción o usa el botón +.');
      return;
    }
    if (_image == null) {
      _showSnack('Selecciona o toma una imagen para analizar.');
      return;
    }
    FocusScope.of(context).unfocus();
    Navigator.pushNamed(context, Routes.result);
  }

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(16);
    final scheme = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final bgPreview = isLight ? const Color(0xFFF0F2F4) : Colors.white.withValues(alpha: 0.06);

    return Scaffold(
      appBar: AppBar(title: const Text('Capturar / Subir imagen')),
      body: Stack(
        children: [
          // ======== contenido principal (sólo preview + saludo) ========
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
            children: [
              Container(
                height: 240,
                decoration: BoxDecoration(borderRadius: radius, color: bgPreview),
                child: ClipRRect(
                  borderRadius: radius,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (_image != null)
                        Image.file(File(_image!.path), fit: BoxFit.cover)
                      else
                        const _GreetingCard(),
                      if (_busy)
                        Container(
                          color: Colors.black26,
                          child: const Center(child: CircularProgressIndicator()),
                        ),
                      // Acciones flotantes cuando hay imagen
                      if (_image != null)
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Row(
                            children: [
                              _MiniChip(
                                icon: Icons.camera_alt_outlined,
                                label: 'Re-tomar',
                                onTap: _busy ? null : _pickFromCamera,
                              ),
                              const SizedBox(width: 8),
                              _MiniChip(
                                icon: Icons.photo_library_outlined,
                                label: 'Cambiar',
                                onTap: _busy ? null : _pickFromGallery,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ======== barra inferior tipo Gemini (siempre visible) ========
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              minimum: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Material(
                color: Colors.transparent,
                child: _GeminiBar(
                  controller: _barCtrl,
                  onPlus: _openPlusOptions,
                  onSend: _onSendFromBar,
                  scheme: scheme,
                  isLight: isLight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ========================= Widgets auxiliares ========================= */

class _GreetingCard extends StatelessWidget {
  const _GreetingCard();

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final sub = isLight ? Colors.black54 : Colors.white70;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Hola',
              style: Theme.of(context)
                  .textTheme
                  .displayMedium
                  ?.copyWith(fontWeight: FontWeight.w900, color: primary)),
          const SizedBox(height: 8),
          Text('¿Qué deseas que detectemos hoy?',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: sub)),
        ],
      ),
    );
  }
}

/// Barra inferior inspirada en Gemini ( +  [input]  enviar )
class _GeminiBar extends StatelessWidget {
  const _GeminiBar({
    required this.controller,
    required this.onPlus,
    required this.onSend,
    required this.scheme,
    required this.isLight,
  });

  final TextEditingController controller;
  final VoidCallback onPlus;
  final VoidCallback onSend;
  final ColorScheme scheme;
  final bool isLight;

  @override
  Widget build(BuildContext context) {
    final fill = isLight ? Colors.white : Colors.white.withValues(alpha: 0.04);

    return Row(
      children: [
        // Botón +
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
          ),
          child: IconButton(
            icon: const Icon(Icons.add),
            onPressed: onPlus,
            tooltip: 'Más opciones',
          ),
        ),
        const SizedBox(width: 8),

        // Campo de entrada
        Expanded(
          child: TextField(
            controller: controller,
            minLines: 1,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Describe o elige una opción…',
              filled: true,
              fillColor: fill,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.10)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(color: scheme.primary, width: 1.4),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),

        // Enviar
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: scheme.primary,
            borderRadius: BorderRadius.circular(14),
          ),
          child: IconButton(
            icon: const Icon(Icons.send_rounded, color: Colors.white),
            onPressed: onSend,
            tooltip: 'Enviar para analizar',
          ),
        ),
      ],
    );
  }
}

/// Chip flotante pequeño sobre el preview
class _MiniChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  const _MiniChip({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final bg = isLight ? Colors.black.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.35);
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              Icon(icon, size: 18, color: Colors.white),
              const SizedBox(width: 6),
              Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Botón redondo grande para el sheet de “+”
class _QuickAction extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  const _QuickAction({required this.label, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final bubble = isLight ? Colors.white : Colors.white.withValues(alpha: 0.06);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 66,
            height: 66,
            decoration: BoxDecoration(color: bubble, shape: BoxShape.circle),
            child: Icon(icon, size: 28, color: scheme.primary),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

/* =============== Calculadora específica de frijol =============== */

class BeanCalcResult {
  final String title;
  final String details;
  BeanCalcResult({required this.title, required this.details});
}

enum BeanCalcMode { severity, dose, loss }

class _BeanCalcSheet extends StatefulWidget {
  const _BeanCalcSheet({required this.onDone});
  final ValueChanged<BeanCalcResult> onDone;

  @override
  State<_BeanCalcSheet> createState() => _BeanCalcSheetState();
}

class _BeanCalcSheetState extends State<_BeanCalcSheet> {
  final _formKey = GlobalKey<FormState>();

  // Selecciones
  String _variety = 'Negro';
  BeanCalcMode _mode = BeanCalcMode.severity;

  // ---- Campos Severidad ----
  int _leaves = 50;
  int _mild = 0;
  int _moderate = 0;
  int _severe = 0;

  // ---- Campos Dosis ----
  String _target = 'Roya (Uromyces phaseoli)';
  double _areaDose = 1.0;
  double _dosePerHa = 0.8; // preset
  String _doseUnit = 'L/ha';

  // Presets simples (puedes extenderlos)
  final Map<String, Map<String, dynamic>> _presets = {
    'Roya (Uromyces phaseoli)': {'dose': 0.8, 'unit': 'L/ha'},
    'Antracnosis (Colletotrichum)': {'dose': 1.0, 'unit': 'L/ha'},
    'Mildeo / Oídio': {'dose': 0.6, 'unit': 'kg/ha'},
    'Pulgón (Aphis craccivora)': {'dose': 0.5, 'unit': 'L/ha'},
    'Mosca blanca (Bemisia)': {'dose': 0.75, 'unit': 'L/ha'},
    'Trips': {'dose': 0.4, 'unit': 'L/ha'},
  };

  // ---- Campos Pérdida ----
  double _areaTotal = 1.0;      // ha
  int _areaAffectedPct = 20;    // %
  int _severityPct = 15;        // %
  double _yieldExpected = 1800; // kg/ha
  double _lossFactor = 0.6;     // factor de conversión severidad→pérdida

  final varieties = const ['Negro','Pinto','Bayo','Rojo','Flor de Mayo','Jamapa'];

  @override
  Widget build(BuildContext context) {
    final insets = MediaQuery.of(context).viewInsets.bottom;
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(bottom: insets),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Calculadora para frijol',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),

              // Variedad
              DropdownButtonFormField<String>(
                value: _variety,
                items: varieties.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                onChanged: (v) => setState(() => _variety = v ?? _variety),
                decoration: const InputDecoration(
                  labelText: 'Variedad de frijol',
                  prefixIcon: Icon(Icons.spa_outlined),
                ),
              ),
              const SizedBox(height: 8),

              // ¿Qué deseas calcular?
              Align(
                alignment: Alignment.centerLeft,
                child: Text('¿Qué deseas calcular?',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                children: [
                  _modeChip('Severidad', BeanCalcMode.severity, scheme),
                  _modeChip('Dosis de tratamiento', BeanCalcMode.dose, scheme),
                  _modeChip('Pérdida de rendimiento', BeanCalcMode.loss, scheme),
                ],
              ),

              const SizedBox(height: 12),
              _buildModeForm(),

              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _onCompute,
                  icon: const Icon(Icons.calculate_outlined),
                  label: const Text('Calcular'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _modeChip(String label, BeanCalcMode m, ColorScheme scheme) {
    final selected = _mode == m;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => setState(() => _mode = m),
      selectedColor: scheme.primary.withValues(alpha: 0.18),
      labelStyle: TextStyle(
        color: selected ? scheme.primary : null,
        fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
      ),
    );
  }

  Widget _buildModeForm() {
    switch (_mode) {
      case BeanCalcMode.severity:
        return _severityForm();
      case BeanCalcMode.dose:
        return _doseForm();
      case BeanCalcMode.loss:
        return _lossForm();
    }
  }

  // ------------------ FORM: Severidad ------------------
  Widget _severityForm() {
    return Column(
      children: [
        _intField(
          label: 'Hojas evaluadas',
          initial: _leaves,
          min: 1,
          onSaved: (v) => _leaves = v,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _intField(label: 'Leves', initial: _mild, min: 0, onSaved: (v) => _mild = v)),
            const SizedBox(width: 8),
            Expanded(child: _intField(label: 'Moderadas', initial: _moderate, min: 0, onSaved: (v) => _moderate = v)),
            const SizedBox(width: 8),
            Expanded(child: _intField(label: 'Severas', initial: _severe, min: 0, onSaved: (v) => _severe = v)),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'Fórmula: (Leves×1 + Moderadas×2 + Severas×3) / (3 × Hojas) × 100',
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  // ------------------ FORM: Dosis ------------------
  Widget _doseForm() {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: _target,
          items: _presets.keys.map((k) => DropdownMenuItem(value: k, child: Text(k))).toList(),
          onChanged: (v) {
            setState(() {
              _target = v ?? _target;
              final p = _presets[_target]!;
              _dosePerHa = (p['dose'] as num).toDouble();
              _doseUnit = p['unit'] as String;
            });
          },
          decoration: const InputDecoration(
            labelText: 'Plaga / enfermedad',
            prefixIcon: Icon(Icons.bug_report_outlined),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _doubleField(
                label: 'Dosis etiqueta',
                suffix: _doseUnit,
                initial: _dosePerHa,
                min: 0.01,
                onSaved: (v) => _dosePerHa = v,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                initialValue: _doseUnit,
                decoration: const InputDecoration(labelText: 'Unidad (L/ha, kg/ha)'),
                onSaved: (v) => _doseUnit = (v ?? _doseUnit).trim(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _doubleField(
          label: 'Área a tratar (ha)',
          initial: _areaDose,
          min: 0.01,
          onSaved: (v) => _areaDose = v,
        ),
      ],
    );
  }

  // ------------------ FORM: Pérdida ------------------
  Widget _lossForm() {
    return Column(
      children: [
        _doubleField(
          label: 'Área total (ha)',
          initial: _areaTotal,
          min: 0.01,
          onSaved: (v) => _areaTotal = v,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _intSliderTile(
                icon: Icons.grid_on_outlined,
                title: 'Área afectada',
                value: _areaAffectedPct,
                onChanged: (v) => setState(() => _areaAffectedPct = v),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _intSliderTile(
                icon: Icons.percent,
                title: 'Severidad',
                value: _severityPct,
                onChanged: (v) => setState(() => _severityPct = v),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _doubleField(
          label: 'Rendimiento esperado (kg/ha)',
          initial: _yieldExpected,
          min: 1,
          onSaved: (v) => _yieldExpected = v,
        ),
        const SizedBox(height: 8),
        _doubleField(
          label: 'Factor pérdida (0.1–1.0)',
          initial: _lossFactor,
          min: 0.1,
          max: 1.0,
          onSaved: (v) => _lossFactor = v,
        ),
        const SizedBox(height: 4),
        const Text(
          'El factor convierte severidad en pérdida. 0.6 ≈ estimación conservadora.',
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  // ------------------ Helpers UI ------------------
  Widget _intField({
    required String label,
    required int initial,
    required int min,
    required ValueChanged<int> onSaved,
  }) {
    return TextFormField(
      initialValue: initial.toString(),
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.number,
      validator: (v) {
        final n = int.tryParse(v ?? '');
        if (n == null || n < min) return '≥ $min';
        return null;
      },
      onSaved: (v) => onSaved(int.parse(v!)),
    );
  }

  Widget _doubleField({
    required String label,
    required double initial,
    required double min,
    double? max,
    String? suffix,
    required ValueChanged<double> onSaved,
  }) {
    return TextFormField(
      initialValue: initial.toStringAsFixed(2),
      decoration: InputDecoration(labelText: label, suffixText: suffix),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: (v) {
        final d = double.tryParse((v ?? '').replaceAll(',', '.'));
        if (d == null || d < min) return '≥ $min';
        if (max != null && d > max) return '≤ $max';
        return null;
      },
      onSaved: (v) => onSaved(double.parse(v!.replaceAll(',', '.'))),
    );
  }

  Widget _intSliderTile({
    required IconData icon,
    required String title,
    required int value,
    required ValueChanged<int> onChanged,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                  Slider(
                    value: value.toDouble(),
                    min: 0.0,
                    max: 100.0,
                    divisions: 20,
                    label: '$value%',
                    onChanged: (v) => onChanged(v.round()),
                  ),
                ],
              ),
            ),
            Text('$value%'),
          ],
        ),
      ),
    );
  }

  // ------------------ Cálculos ------------------
  void _onCompute() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    switch (_mode) {
      case BeanCalcMode.severity:
        if (_mild + _moderate + _severe > _leaves) {
          _showError('La suma de hojas (leve+mod+sev) no puede superar las hojas evaluadas.');
          return;
        }
        final sev = ((_mild * 1 + _moderate * 2 + _severe * 3) / (3 * _leaves)) * 100.0;
        String level, action;
        if (sev < 10) {
          level = 'Baja';
          action = 'Continuar monitoreo. No se recomienda tratamiento por ahora.';
        } else if (sev < 30) {
          level = 'Moderada';
          action = 'Valorar tratamiento preventivo y mejorar ventilación/cobertura.';
        } else {
          level = 'Alta';
          action = 'Aplicar tratamiento recomendado y repetir evaluación en 3–5 días.';
        }
        widget.onDone(BeanCalcResult(
          title: 'Severidad estimada (${sev.toStringAsFixed(1)}%)',
          details:
              'Variedad: $_variety\n'
              'Hojas: $_leaves  (L:$_mild  M:$_moderate  S:$_severe)\n'
              'Nivel: $level\n\n'
              'Acción sugerida:\n$action',
        ));
        break;

      case BeanCalcMode.dose:
        final total = _dosePerHa * _areaDose;
        widget.onDone(BeanCalcResult(
          title: 'Dosis total para $_target',
          details:
              'Variedad: $_variety\n'
              'Área a tratar: ${_areaDose.toStringAsFixed(2)} ha\n'
              'Dosis etiqueta: ${_dosePerHa.toStringAsFixed(2)} $_doseUnit\n'
              'Producto total: ${total.toStringAsFixed(2)} ${_doseUnit.split("/").first}\n\n'
              'Nota: respeta intervalo de seguridad y rotación de ingredientes activos.',
        ));
        break;

      case BeanCalcMode.loss:
        final affectedFrac = (_areaAffectedPct / 100.0) * (_severityPct / 100.0);
        final lossKg = _areaTotal * _yieldExpected * affectedFrac * _lossFactor;
        final lossPct = (lossKg / (_areaTotal * _yieldExpected)) * 100.0;
        widget.onDone(BeanCalcResult(
          title: 'Pérdida estimada: ${lossKg.toStringAsFixed(0)} kg',
          details:
              'Variedad: $_variety\n'
              'Área total: ${_areaTotal.toStringAsFixed(2)} ha\n'
              'Área afectada: $_areaAffectedPct%\n'
              'Severidad: $_severityPct%\n'
              'Rend. esperado: ${_yieldExpected.toStringAsFixed(0)} kg/ha\n'
              'Factor: ${_lossFactor.toStringAsFixed(2)}\n\n'
              'Pérdida ≈ ${lossPct.toStringAsFixed(1)}% del rendimiento total.\n'
              'Recomendación: prioriza control en zonas con mayor severidad y reevalúa en 5–7 días.',
        ));
        break;
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
