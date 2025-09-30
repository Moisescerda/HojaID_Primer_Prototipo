import 'package:flutter/material.dart';
import '../Routes.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Tamaños responsivos para el logo y el botón
            final double maxLogoWidth =
                (constraints.maxWidth * 0.85).clamp(240.0, 620.0);
            final double maxLogoHeight =
                (constraints.maxHeight * 0.50).clamp(180.0, 420.0);
            final double buttonMaxWidth =
                (constraints.maxWidth * 0.90).clamp(220.0, 520.0);

            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // LOGO centrado y grande (sin estirarse)
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: maxLogoWidth,
                      maxHeight: maxLogoHeight,
                    ),
                    child: Image.asset(
                      'android/assets/images/LOGO_HOJA_ID_HOME.png',
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                          Icon(Icons.eco, size: 120, color: scheme.primary),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Botón Comenzar centrado bajo el logo
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: buttonMaxWidth),
                    child: SizedBox(
                      height: 56,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        onPressed: () =>
                            Navigator.pushReplacementNamed(context, Routes.login),
                        child: const Text(
                          'Comenzar',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
