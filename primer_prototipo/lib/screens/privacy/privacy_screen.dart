import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final p = Theme.of(context).textTheme.bodyMedium;
    final h = Theme.of(context)
        .textTheme
        .titleMedium
        ?.copyWith(fontWeight: FontWeight.w800);

    return Scaffold(
      appBar: AppBar(title: const Text('Privacidad')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Resumen', style: h),
            const SizedBox(height: 8),
            Text(
              'Cuidamos tus datos. Usamos tu información para mejorar diagnósticos, '
              'mostrar clima y personalizar recomendaciones. No vendemos tus datos.',
              style: p,
            ),
            const SizedBox(height: 16),
            Text('Qué recolectamos', style: h),
            const SizedBox(height: 8),
            Text('• Imágenes que subes\n• Ubicación aproximada\n• Historial de diagnósticos', style: p),
            const SizedBox(height: 16),
            Text('Tus controles', style: h),
            const SizedBox(height: 8),
            Text('Puedes solicitar la eliminación de tus datos y descargar una copia.', style: p),
          ],
        ),
      ),
    );
  }
}
