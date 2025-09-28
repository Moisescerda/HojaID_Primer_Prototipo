import 'package:flutter/material.dart';
import '../../Routes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  bool get _isValid {
    final emailOk =
        RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(_emailCtrl.text.trim());
    return _nameCtrl.text.trim().isNotEmpty &&
        _passCtrl.text.isNotEmpty &&
        emailOk;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacementNamed(context, Routes.home);
    }
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear cuenta',
            style: TextStyle(fontWeight: FontWeight.w800)),
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
                // Nombre
                TextFormField(
                  controller: _nameCtrl,
                  decoration: InputDecoration(
                    hintText: 'Nombre completo',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.08),
                    prefixIcon: const Icon(Icons.person_outline),
                    hintStyle: const TextStyle(color: Colors.white54),
                    enabledBorder: _pillBorder(Colors.white24),
                    focusedBorder: _pillBorder(green),
                    errorBorder: _pillBorder(Colors.redAccent),
                    focusedErrorBorder: _pillBorder(Colors.redAccent),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 18),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Ingrese su nombre' : null,
                ),
                const SizedBox(height: 16),

                // Email
                TextFormField(
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
                    errorBorder: _pillBorder(Colors.redAccent),
                    focusedErrorBorder: _pillBorder(Colors.redAccent),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 18),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Ingrese su correo';
                    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                        .hasMatch(v.trim());
                    return ok ? null : 'Correo no válido';
                  },
                ),
                const SizedBox(height: 16),

                // Password
                TextFormField(
                  controller: _passCtrl,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    hintText: 'Contraseña',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.08),
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _obscure = !_obscure),
                      icon: Icon(
                          _obscure ? Icons.visibility_off : Icons.visibility),
                    ),
                    hintStyle: const TextStyle(color: Colors.white54),
                    enabledBorder: _pillBorder(Colors.white24),
                    focusedBorder: _pillBorder(green),
                    errorBorder: _pillBorder(Colors.redAccent),
                    focusedErrorBorder: _pillBorder(Colors.redAccent),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 18),
                  ),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Ingrese una contraseña' : null,
                ),

                const SizedBox(height: 24),

                // Registrarse
                ElevatedButton(
                  onPressed: _isValid ? _submit : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    shape:
                        RoundedRectangleBorder(borderRadius: pill),
                    textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2),
                  ),
                  child: const Text('REGISTRARSE'),
                ),

                const SizedBox(height: 16),

                // Divisor O
                Row(
                  children: [
                    const Expanded(child: Divider(thickness: 1)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child:
                          Text('O', style: TextStyle(color: Colors.white70)),
                    ),
                    const Expanded(child: Divider(thickness: 1)),
                  ],
                ),
                const SizedBox(height: 16),

                // Google button
                InkWell(
                  onTap: () {/* TODO: Google sign-up */},
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
                        Icon(Icons.g_mobiledata, size: 28, color: Colors.black87),
                        SizedBox(width: 8),
                        Text(
                          'Regístrate con Google',
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Ya tienes cuenta
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('¿Ya tienes cuenta? ',
                        style: TextStyle(color: Colors.white70)),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
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
      ),
    );
  }
}
