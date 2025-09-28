import 'package:flutter/material.dart';

class ConsultScreen extends StatelessWidget {
  const ConsultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Consultar")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Escribe tu consulta...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.08),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: const [
                  ListTile(
                    leading: Icon(Icons.question_answer, color: Colors.green),
                    title: Text("¿Cómo tratar plaga X en maíz?"),
                    subtitle: Text("Respuesta recibida - hace 2 días"),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.question_answer, color: Colors.green),
                    title: Text("¿Qué fertilizante usar en tomates?"),
                    subtitle: Text("Respuesta recibida - hace 1 semana"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
