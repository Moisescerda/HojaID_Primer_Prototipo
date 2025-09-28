import 'package:flutter/material.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({Key? key}) : super(key: key);

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final faqs = const [
    ('¿Cómo diagnostico una hoja?', 'Ve a Diagnosticar, toma una foto clara y envíala.'),
    ('¿Cómo recibo recomendaciones?', 'Tras el diagnóstico, verás tratamientos sugeridos y notas.'),
    ('¿Puedo exportar datos?', 'Sí, en Reportes puedes generar PDF o CSV.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Centro de ayuda')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          ...faqs.map((e) => Card(
                child: ExpansionTile(
                  leading: const Icon(Icons.help_outline),
                  title: Text(e.$1, style: const TextStyle(fontWeight: FontWeight.w700)),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Text(e.$2),
                    )
                  ],
                ),
              )),
          const SizedBox(height: 16),
          Center(
            child: OutlinedButton.icon(
              icon: const Icon(Icons.chat_bubble_outline),
              label: const Text('Contactar soporte'),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Abrir canal de soporte (demo)')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
