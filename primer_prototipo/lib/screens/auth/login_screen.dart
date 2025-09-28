import 'package:flutter/material.dart';
import '../../Routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  bool get _isValid {
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text;
    final emailOk = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
    return emailOk && pass.isNotEmpty;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacementNamed(context, Routes.home);
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final green = scheme.primary;
    final pillRadius = BorderRadius.circular(28);

    InputBorder _pillBorder(Color c) => OutlineInputBorder(
      borderRadius: pillRadius,
      borderSide: BorderSide(color: c, width: 1),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login', style: TextStyle(fontWeight: FontWeight.w800)),
        leading: const BackButton(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          child: Form(
            key: _formKey,
            onChanged: () => setState(() {}),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                // Email
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'Dirección de correo electrónico',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.08),
                    prefixIcon: const Icon(Icons.email_outlined),
                    hintStyle: const TextStyle(color: Colors.white54),
                    enabledBorder: _pillBorder(Colors.white24),
                    focusedBorder: _pillBorder(green),
                    errorBorder: _pillBorder(Colors.redAccent),
                    focusedErrorBorder: _pillBorder(Colors.redAccent),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Ingrese su correo';
                    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim());
                    return ok ? null : 'Correo no válido';
                  },
                ),
                const SizedBox(height: 16),

                // Password
                TextFormField(
                  controller: _passCtrl,
                  obscureText: _obscure,
                  style: const TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'Introducir la contraseña',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.08),
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _obscure = !_obscure),
                      icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                    ),
                    hintStyle: const TextStyle(color: Colors.white54),
                    enabledBorder: _pillBorder(Colors.white24),
                    focusedBorder: _pillBorder(green),
                    errorBorder: _pillBorder(Colors.redAccent),
                    focusedErrorBorder: _pillBorder(Colors.redAccent),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                  ),
                  validator: (v) => (v == null || v.isEmpty) ? 'Ingrese su contraseña' : null,
                ),

                const SizedBox(height: 24),

                // CONTINUAR
                ElevatedButton(
                  onPressed: _isValid ? _submit : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 1.2),
                  ),
                  child: const Text('CONTINUAR'),
                ),

                const SizedBox(height: 16),

                // Ayuda
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('¿Ha olvidado sus datos de acceso?  ',
                        style: TextStyle(color: Colors.white70)),
                    InkWell(
                      onTap: () => Navigator.pushNamed(context, Routes.reset),
                      child: Text('Consigue ayuda',
                          style: TextStyle(
                            color: green,
                            fontWeight: FontWeight.w800,
                          )),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Divider con "O"
                Row(
                  children: [
                    const Expanded(child: Divider(thickness: 1)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('O', style: TextStyle(color: Colors.white70)),
                    ),
                    const Expanded(child: Divider(thickness: 1)),
                  ],
                ),

                const SizedBox(height: 16),

                // Google button (píldora blanca)
                InkWell(
                  onTap: () {/* TODO: Google sign-in */},
                  borderRadius: BorderRadius.circular(32),
                  child: Container(
                    height: 54,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        // Usa tu asset del logo si lo tienes:
                        // Image.asset('assets/google_g.png', width: 22, height: 22),
                        Icon(Icons.g_mobiledata, size: 28, color: Colors.black87),
                        SizedBox(width: 8),
                        Text(
                          'Inicia sesión con Google',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Registro
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('¿No tienes una cuenta? ',
                        style: TextStyle(color: Colors.white70)),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, Routes.register),
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      child: Text('Regístrese',
                          style: TextStyle(
                            color: green,
                            fontWeight: FontWeight.w900,
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
