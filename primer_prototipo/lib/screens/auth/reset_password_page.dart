import 'package:flutter/material.dart';
import '../../Routes.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final green = scheme.primary;
    final pill = BorderRadius.circular(28);

    InputBorder _pillBorder(Color c) => OutlineInputBorder(
          borderRadius: pill,
          borderSide: BorderSide(color: c, width: 1),
        );

    void _sendLink() {
      final email = _emailCtrl.text.trim();
      final ok =
          RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
      if (!ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ingrese un correo válido')),
        );
        return;
      }
      // TODO: lógica para enviar correo
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Se envió el enlace de recuperación')),
      );
      Navigator.pushReplacementNamed(context, Routes.login);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar contraseña',
            style: TextStyle(fontWeight: FontWeight.w800)),
        leading: const BackButton(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Ingresa tu correo para enviarte un enlace de recuperación',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 20),

              // Email pill
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Dirección de correo electrónico',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.08),
                  prefixIcon: const Icon(Icons.email_outlined),
                  hintStyle: const TextStyle(color: Colors.white54),
                  enabledBorder: _pillBorder(Colors.white24),
                  focusedBorder: _pillBorder(green),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 18),
                ),
              ),

              const SizedBox(height: 24),

              // ENVIAR ENLACE
              ElevatedButton(
                onPressed: _sendLink,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(borderRadius: pill),
                  textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0),
                ),
                child: const Text('ENVIAR ENLACE'),
              ),

              const SizedBox(height: 20),

              // Volver a iniciar sesión
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('¿Recordaste tu clave? ',
                      style: TextStyle(color: Colors.white70)),
                  TextButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, Routes.login),
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    child: Text('Inicia sesión',
                        style: TextStyle(
                            color: green, fontWeight: FontWeight.w900)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
