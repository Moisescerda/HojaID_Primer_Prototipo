import 'package:flutter/material.dart';

// Pantallas base
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/dashboard_screen.dart';
import 'screens/capture/capture_screen.dart';
import 'screens/diagnosis/result_screen.dart';
import 'screens/recommendations/recommendations_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/auth/reset_password_page.dart';
import 'screens/schedule/schedule_screen.dart';
import 'screens/notifications/notifications_screen.dart';
import 'screens/explore/explore_screen.dart';
import 'screens/consult/consult_screen.dart';

// Menú lateral extra (si ya las tienes)
import 'screens/history/diagnosis_history_screen.dart';
import 'screens/reports/reports_screen.dart';
import 'screens/about/about_license_screen.dart';
import 'screens/privacy/privacy_screen.dart';
import 'screens/help/help_center_screen.dart';

// ☆ NUEVAS de Exploración
import 'screens/explore/crops_screen.dart';
import 'screens/explore/treatments_screen.dart';
import 'screens/explore/weather_screen.dart';
import 'screens/explore/map_plots_screen.dart';

class Routes {
  // Rutas existentes
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String capture = '/capture';
  static const String result = '/result';
  static const String recommendations = '/recommendations';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String reset = '/reset';
  static const String schedule = '/schedule';
  static const String notifications = '/notifications';
  static const String explore = '/explore';
  static const String consult = '/consult';

  // Menú lateral extra (si ya las tienes)
  static const String diagnosisHistory = '/diagnosis-history';
  static const String reports = '/reports';
  static const String aboutLicense = '/about-license';
  static const String privacy = '/privacy';
  static const String helpCenter = '/help-center';

  // ☆ NUEVAS (Exploración)
  static const String crops = '/crops';
  static const String treatments = '/treatments';
  static const String weather = '/weather';
  static const String mapPlots = '/map-plots';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (ctx) => const SplashScreen(),
      onboarding: (ctx) => const OnboardingScreen(),
      login: (ctx) => const LoginScreen(),
      register: (ctx) => const RegisterScreen(),
      home: (ctx) => const DashboardScreen(),
      capture: (ctx) => const CaptureScreen(),
      result: (ctx) => const ResultScreen(),
      recommendations: (ctx) => const RecommendationsScreen(),
      profile: (ctx) => const ProfileScreen(),
      settings: (ctx) => const SettingsScreen(),
      reset: (ctx) => const ResetPasswordPage(),
      schedule: (ctx) => const ScheduleScreen(),
      notifications: (ctx) => const NotificationsScreen(),
      explore: (ctx) => const ExploreScreen(),
      consult: (ctx) => const ConsultScreen(),

      // Menú lateral extra
      diagnosisHistory: (ctx) => const DiagnosisHistoryScreen(),
      reports: (ctx) => const ReportsScreen(),
      aboutLicense: (ctx) => const AboutLicenseScreen(),
      privacy: (ctx) => const PrivacyScreen(),
      helpCenter: (ctx) => const HelpCenterScreen(),

      // ☆ NUEVAS (Exploración)
      crops: (ctx) => const CropsScreen(),
      treatments: (ctx) => const TreatmentsScreen(),
      weather: (ctx) => const WeatherScreen(),
      mapPlots: (ctx) => const MapPlotsScreen(),
    };
  }
}
