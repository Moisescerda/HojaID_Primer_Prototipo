import 'package:flutter/material.dart';
import '../../Routes.dart';
import '../../theme_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameCtrl =
      TextEditingController(text: 'Moisés (ejemplo)');
  final TextEditingController _roleCtrl =
      TextEditingController(text: 'Productor / Técnico / Estudiante');

  @override
  void dispose() {
    _nameCtrl.dispose();
    _roleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ThemeController.instance;

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: const [
              CircleAvatar(radius: 36, child: Icon(Icons.person, size: 42)),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Tu perfil',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
              )
            ],
          ),
          const SizedBox(height: 16),

          // Datos editables
          TextField(
            controller: _nameCtrl,
            decoration: InputDecoration(
              labelText: 'Nombre',
              prefixIcon: const Icon(Icons.badge_outlined),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              filled: true,
              fillColor: Colors.white.withOpacity(0.06),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _roleCtrl,
            decoration: InputDecoration(
              labelText: 'Rol',
              prefixIcon: const Icon(Icons.work_outline),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              filled: true,
              fillColor: Colors.white.withOpacity(0.06),
            ),
          ),
          const SizedBox(height: 12),

          // Guardar cambios (mock)
          ElevatedButton.icon(
            icon: const Icon(Icons.save_outlined),
            label: const Text('Guardar cambios'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Perfil actualizado (ejemplo)')),
              );
            },
          ),
          const SizedBox(height: 24),

          const Text('Personalización',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),

          // 🔁 Cambio global de tema claro/oscuro
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.brightness_6_outlined),
            title: const Text('Modo oscuro'),
            subtitle: const Text('Activa/Desactiva el tema oscuro de la app'),
            trailing: AnimatedBuilder(
              animation: controller,
              builder: (_, __) => Switch(
                value: controller.isDark,
                onChanged: (val) => controller.toggle(val),
                activeColor: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),

          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, Routes.settings),
            child: const Text('Más ajustes'),
          ),
        ],
      ),
    );
  }
}
