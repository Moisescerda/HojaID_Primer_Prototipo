import 'package:flutter/material.dart';
import '../Routes.dart';
// ignore: unused_import
import '../screens/auth/login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.eco, size: 96, color: Colors.green[700]),
            const SizedBox(height: 16),
            const Text('HojaID',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, Routes.login),
              child: const Text('Comenzar'),
            )
          ],
        ),
      ),
    );
  }
}
