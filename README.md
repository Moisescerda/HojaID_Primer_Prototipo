Fecha: 27/09/2025
Interfaces listas
    1.	Pantalla de inicio (splash_screen.dart)
    2.	Pantalla de bienvenida / Onboarding (onboarding_screen.dart)
    3.	Iniciar sesión (login_screen.dart)
    4.	Registro (register_screen.dart)
    5.	Restablecer contraseña (reset_password_page.dart)
    6.	Dashboard (dashboard_screen.dart)
    7.	Capturar / Subir imagen (capture_screen.dart)
    8.	Resultado de diagnóstico (result_screen.dart)
    9.	Recomendaciones (recommendations_screen.dart)
    10.	Perfil (profile_screen.dart)
    11.	Ajustes (settings_screen.dart)
    12.	Programar / Calendario (schedule_screen.dart)
    13.	Notificaciones (notifications_screen.dart)
    14.	Exploración (explore_screen.dart)
    15.	Consultar (consult_screen.dart)
    16.	Historial de diagnósticos (diagnosis_history_screen.dart)
    17.	Reportes (reports_screen.dart)
    18.	Acerca de / Licencias (about_license_screen.dart)
    19.	Privacidad (privacy_screen.dart)
    20.	Centro de ayuda (help_center_screen.dart)
Apartados / Navegación
Barra inferior
    1.	Programar (schedule_screen.dart)
    2.	Diagnosticar (capture_screen.dart)
    3.	Consultar (consult_screen.dart)
    4.	Notificaciones (notifications_screen.dart)
Cinta superior
    1.	Inicio (dashboard_screen.dart)
    2.	Exploración (explore_screen.dart)
Menú lateral
    1.	Historial de diagnósticos (diagnosis_history_screen.dart)
    2.	Recomendaciones (recommendations_screen.dart)
    3.	Reportes (reports_screen.dart)
    4.	Centro de ayuda (help_center_screen.dart)
    5.	Privacidad (privacy_screen.dart)
    6.	Acerca de / Licencias (about_license_screen.dart)
    7.	Cerrar sesión (acción → login_screen.dart)
Acceso rápido (AppBar)
•	Perfil (profile_screen.dart)
----------------------------------------------------------------------------------------------------------------------
Fecha: 28/09/2025 — Cambios y nuevas funcionalidades 
1.	Dashboard (dashboard_screen.dart)
    1.	Feed de comunidad en el área central (publicaciones con foto/texto, “Me gusta” y respuestas).
    2.	Crear publicación en hoja inferior (Cámara / Galería / Descripción / Publicar) sin salir del Dashboard.
    3.	Cinta superior con Inicio y Exploración (icono de mapa).
    4.	Barra inferior con 4 ítems: Calendario, Diagnosticar, Consulta, Notificaciones.
2.	Capturar / Subir imagen (capture_screen.dart)
    1.	Barra tipo Gemini: botón + (Cámara, Galería, Calculadora), campo de texto y Enviar.
    2.	Preview con chips “Re-tomar / Cambiar” cuando ya hay foto.
    3.	Calculadora específica de frijol:
       2.3.1 Severidad (%) por conteo de hojas.
       2.3.2 Dosis total según área y dosis/ha (presets de plagas/enfermedades).
       2.3.3 Pérdida estimada de rendimiento (kg y %).
4.	Manejo de permisos (cámara/galería) con permission_handler.
3.	Exploración (explore_screen.dart)
    1.	Grid con subtítulos visibles, buscador superior y tarjetas compactas.
    2.	Nuevas pantallas del módulo:
      3.2.1 Cultivos (crops_screen.dart): lista por cultivo con estado, % de desarrollo, producción y posible pérdida.
      3.2.2 Tratamientos (treatments_screen.dart): ligado a diagnóstico; tratamientos por cultivo/plaga.
      3.2.3 Clima (weather_screen.dart): estilo “Google weather”; temperatura, humedad, lluvia; permiso de ubicación con geolocator.
      3.2.4 Mapa / Parcelas (map_screen.dart): mapeo por dimensiones o caminando; zonas, afectaciones, % de daño y notas.
4.	Programar / Calendario (schedule_screen.dart)
    1.	Calendario interactivo con TableCalendar.
    2.	Selección de fecha, alta/edición de tareas y lista de actividades debajo.
5.	Perfil (profile_screen.dart)
    1.	Personalización de perfil.
    2.	Cambio de tema claro/oscuro.
6.	Menú lateral (widgets/app_drawer.dart)
    1.	Historial de diagnósticos.
    2.	Recomendaciones.
    3.	Reportes.
    4.	Centro de ayuda.
    5.	Privacidad.
    6.	Acerca de / Licencias.
    7.	Cerrar sesión → redirige a login.
7.	Ajustes técnicos y permisos
    1.	Temas en main.dart: mejoras en modo claro (contraste, CardThemeData) y cambio de withOpacity → withValues.
    2.	AndroidManifest.xml: CAMERA, READ_MEDIA_IMAGES (Android 13+), READ_EXTERNAL_STORAGE (≤12).
    3.	Info.plist: NSCameraUsageDescription, NSPhotoLibraryUsageDescription, NSPhotoLibraryAddUsageDescription.
    4.	pubspec.yaml actualizado con: image_picker, permission_handler, geolocator, table_calendar.
