import 'package:flutter/material.dart';
import '../Routes.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bienvenido')),
      body: PageView(
        children: const [
          OnboardingCard(
              title: 'Fotografías',
              body: 'Toma o sube fotos de tus cultivos para diagnóstico.'),
          OnboardingCard(
              title: 'Recomendaciones',
              body: 'Soluciones eco-amigables y control biológico.'),
          OnboardingCard(
              title: 'Mapeo',
              body: 'Ubica zonas afectadas con geolocalización.'),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () => Navigator.pushReplacementNamed(context, Routes.login),
            child: const Text('Iniciar sesión'),
          ),
        ),
      ),
    );
  }
}

class OnboardingCard extends StatelessWidget {
  final String title;
  final String body;
  const OnboardingCard({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.camera_alt, size: 92, color: Colors.green),
          const SizedBox(height: 24),
          Text(title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(body, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
