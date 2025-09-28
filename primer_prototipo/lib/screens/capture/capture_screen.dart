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
  final TextEditingController _descCtrl = TextEditingController();

  XFile? _image;
  bool _busy = false;

  @override
  void dispose() {
    _descCtrl.dispose();
    super.dispose();
  }

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
    // iOS: usa photos | Android 13+: photos | Android ≤12: storage
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

      // intenta primero photos (Android 13+), luego storage (≤12)
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
        content: Text(
            'Para continuar necesitamos el permiso de $cual. ¿Abrir ajustes de la app?'),
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

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(12);
    final bgPreview = Theme.of(context).brightness == Brightness.light
        ? const Color(0xFFF0F2F4)
        : Colors.white.withOpacity(0.06);

    return Scaffold(
      appBar: AppBar(title: const Text('Capturar / Subir imagen')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // PREVIEW
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(borderRadius: radius, color: bgPreview),
              child: ClipRRect(
                borderRadius: radius,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (_image != null)
                      Image.file(File(_image!.path), fit: BoxFit.cover)
                    else
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.image_outlined, size: 48),
                            SizedBox(height: 8),
                            Text('Sin imagen seleccionada'),
                          ],
                        ),
                      ),
                    if (_busy)
                      Container(
                        color: Colors.black26,
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // BOTONES
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _busy ? null : _pickFromCamera,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Cámara'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _busy ? null : _pickFromGallery,
                    icon: const Icon(Icons.image),
                    label: const Text('Galería'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // DESCRIPCIÓN
            TextField(
              controller: _descCtrl,
              minLines: 1,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Descripción de síntomas',
                hintText: 'Ej. manchas, coloración, ubicación, etc.',
              ),
            ),

            const SizedBox(height: 12),
            // ANALIZAR
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _busy
                    ? null
                    : () {
                        if (_image == null) {
                          _showSnack('Selecciona o toma una imagen primero.');
                          return;
                        }
                        Navigator.pushNamed(context, Routes.result);
                      },
                child: const Text('Analizar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
