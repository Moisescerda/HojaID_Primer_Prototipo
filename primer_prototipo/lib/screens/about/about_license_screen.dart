import 'package:flutter/material.dart';

class AboutLicenseScreen extends StatelessWidget {
  const AboutLicenseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Acerca de / Licencias')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('HojaID'),
              subtitle: const Text('Versión 1.0.0 • © 2025'),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.code),
              title: const Text('Ver licencias de paquetes'),
              subtitle: const Text('Mostrar licencias de software de terceros'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showLicensePage(
                  context: context,
                  applicationName: 'HojaID',
                  applicationVersion: '1.0.0',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
