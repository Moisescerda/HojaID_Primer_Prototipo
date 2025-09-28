import 'package:flutter/material.dart';
import '../Routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: scheme.primary),
              currentAccountPicture: const CircleAvatar(child: Text('M')),
              accountName: const Text('Moisés'),
              accountEmail: const Text('moises@ejemplo.com'),
            ),

            _tile(
              icon: Icons.history,
              text: 'Historial de diagnósticos',
              onTap: () => Navigator.pushNamed(context, Routes.diagnosisHistory),
            ),
            _tile(
              icon: Icons.fact_check_outlined,
              text: 'Recomendaciones',
              onTap: () => Navigator.pushNamed(context, Routes.recommendations),
            ),
            _tile(
              icon: Icons.picture_as_pdf_outlined,
              text: 'Reportes',
              onTap: () => Navigator.pushNamed(context, Routes.reports),
            ),
            _tile(
              icon: Icons.help_center_outlined,
              text: 'Centro de ayuda',
              onTap: () => Navigator.pushNamed(context, Routes.helpCenter),
            ),
            _tile(
              icon: Icons.privacy_tip_outlined,
              text: 'Privacidad',
              onTap: () => Navigator.pushNamed(context, Routes.privacy),
            ),
            _tile(
              icon: Icons.info_outline,
              text: 'Acerca de / Licencias',
              onTap: () => Navigator.pushNamed(context, Routes.aboutLicense),
            ),

            const Divider(height: 24),
            _tile(
              icon: Icons.logout,
              text: 'Cerrar sesión',
              onTap: () => Navigator.pushNamedAndRemoveUntil(
                context, Routes.login, (route) => false),
            ),
          ],
        ),
      ),
    );
  }

  ListTile _tile({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
