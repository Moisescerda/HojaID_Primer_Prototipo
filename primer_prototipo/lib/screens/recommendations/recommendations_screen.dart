import 'package:flutter/material.dart';

class RecommendationsScreen extends StatelessWidget {
  const RecommendationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Base Agroecológica')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: const [
          ListTile(
              title: Text('Control biológico: Tronchus parasiticus'),
              subtitle: Text('Descripción y modo de empleo')),
          ListTile(
              title: Text('Bioinsumo: Bacillus subtilis'),
              subtitle: Text('Dosis y preparación')),
          ListTile(
              title: Text('Trampa: Feromona para plaga X'),
              subtitle: Text('Cómo instalar')),
        ],
      ),
    );
  }
}
