import 'package:flutter/material.dart';
import 'Routes.dart';
import 'theme_controller.dart';

void main() {
  runApp(const AgroApp());
}

class AgroApp extends StatelessWidget {
  const AgroApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color seed = Color(0xFF41C11A);

    return AnimatedBuilder(
      animation: ThemeController.instance,
      builder: (context, _) {
        return MaterialApp(
          title: 'HojaID',
          debugShowCheckedModeBanner: false,
          theme: _lightTheme(seed),   // 👈 modo CLARO mejorado
          darkTheme: _darkTheme(seed),
          themeMode: ThemeController.instance.mode,
          initialRoute: Routes.splash,
          routes: Routes.getRoutes(),
        );
      },
    );
  }
}

ThemeData _lightTheme(Color seed) {
  final cs = ColorScheme.fromSeed(
    seedColor: seed,
    brightness: Brightness.light,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: cs,

    // Fondo gris claro para que las cards blancas destaquen
    scaffoldBackgroundColor: const Color(0xFFF2F4F7),

    // AppBar blanco y texto/íconos oscuros
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.black87),
      titleTextStyle: TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.w800,
        fontSize: 20,
      ),
    ),

    // 🟩 Cards blancas con borde suave y sombra ligera (sin surfaceTint)
    cardColor: Colors.white,
    cardTheme: const CardThemeData(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.black12,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        side: BorderSide(color: Color(0xFFE6E9EE)),
      ),
    ),

    // Bottom bar clara
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: seed,
      unselectedItemColor: Colors.black54,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
    ),

    // Inputs “pill” claros
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF0F2F4),
      hintStyle: const TextStyle(color: Colors.black45),
      prefixIconColor: Colors.black54,
      suffixIconColor: Colors.black54,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: const BorderSide(color: Color(0xFFE0E3E7)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: const BorderSide(color: Color(0xFFE0E3E7)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: BorderSide(color: seed, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
    ),

    // Tipografías con alto contraste en claro
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: Colors.black87),
      displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.black87),
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.black87),
      titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black87),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),
      labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
    ),

    dividerTheme: const DividerThemeData(color: Color(0xFFE6E9EE)),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

ThemeData _darkTheme(Color seed) {
  final cs = ColorScheme.fromSeed(
    seedColor: seed,
    brightness: Brightness.dark,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: cs, 

    scaffoldBackgroundColor: const Color(0xFF0E0F10),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
    ),

    // Tarjetas oscuras sin overlay
    applyElevationOverlayColor: false,
    cardColor: const Color(0xFF1B1C1E),
    cardTheme: const CardThemeData(
      color: Color(0xFF1B1C1E),
      elevation: 0,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color(0xFF121212),
      selectedItemColor: seed,
      unselectedItemColor: Colors.white70,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
    ),

    // Inputs “pill” oscuros
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withOpacity(0.08),
      hintStyle: const TextStyle(color: Colors.white54),
      prefixIconColor: Colors.white70,
      suffixIconColor: Colors.white70,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: BorderSide(color: seed, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
    ),

    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: Colors.white),
      displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white),
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white),
      titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.white70),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
      labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
    ),

    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
