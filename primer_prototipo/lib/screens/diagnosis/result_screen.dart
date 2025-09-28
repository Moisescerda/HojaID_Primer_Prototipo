import 'package:flutter/material.dart';
import '../../Routes.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const diagnosis = 'Probable: Roya (fúngica)';
    const confidence = '87%';

    return Scaffold(
      appBar: AppBar(title: const Text('Resultado')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Diagnóstico',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(diagnosis, style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            const Text('Confianza: $confidence'),
            const SizedBox(height: 16),
            const Text('Recomendaciones',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
                '- Control biológico: liberar parasitoides X\n- Bioinsumo: fórmula Y\n- Trampas: tipo Z'),
            const SizedBox(height: 16),
            ElevatedButton(
                onPressed: () =>
                    Navigator.pushNamed(context, Routes.recommendations),
                child: const Text('Ver base agroecológica')),
          ],
        ),
      ),
    );
  }
}
