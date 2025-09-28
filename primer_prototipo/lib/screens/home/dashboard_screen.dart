import 'package:flutter/material.dart';
import '../../Routes.dart';
import '../../widgets/app_drawer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _current = 1;   // Diagnosticar por defecto
  int _topIndex = 0;  // 0=home, 1=explorar

  void _onBottomTap(int i) {
    setState(() => _current = i);
    switch (i) {
      case 0: Navigator.pushNamed(context, Routes.schedule); break;
      case 1: Navigator.pushNamed(context, Routes.capture); break;
      case 2: Navigator.pushNamed(context, Routes.consult); break;
      case 3: Navigator.pushNamed(context, Routes.notifications); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final green = Theme.of(context).colorScheme.primary;

    return Scaffold(
      // 👇 Drawer con las opciones del menú lateral
      drawer: const AppDrawer(),

      appBar: AppBar(
        // 👇 Este botón abre el Drawer
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.eco, size: 22),
            SizedBox(width: 6),
            Text('HojaID', style: TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, Routes.profile),
            icon: const CircleAvatar(child: Text('M')),
            tooltip: 'Perfil',
          ),
        ],
      ),

      body: Column(
        children: [
          // Cinta superior (Home + Exploración)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Theme.of(context).dividerColor),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _TopIcon(
                  icon: Icons.home_rounded,
                  active: _topIndex == 0,
                  activeColor: green,
                  onTap: () => setState(() => _topIndex = 0),
                ),
                const SizedBox(width: 24),
                _TopIcon(
                  icon: Icons.map_outlined,
                  active: _topIndex == 1,
                  activeColor: green,
                  onTap: () {
                    setState(() => _topIndex = 1);
                    Navigator.pushNamed(context, Routes.explore);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),

          // Contenido
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: const [
                FeatureCard(
                  title: 'Chequeo de salud',
                  subtitle:
                      'Recibe las identificaciones instantáneas y sugerencias de tratamiento',
                  emoji: '🖼️',
                ),
                FeatureCard(
                  title: 'Sin embargo parcelas',
                  subtitle:
                      'Agrega una parcela para activar alertas, pronósticos y recomendaciones',
                  emoji: '🌳',
                ),
                FeatureCard(
                  title: 'Monitoreo satelital',
                  subtitle:
                      'Actívelo para detectar problemas y medir el progreso',
                  emoji: '🛰️',
                  closable: true,
                ),
                FeatureCard(
                  title: 'Invita amigos',
                  subtitle:
                      'Gana créditos por cada amigo que se una con tu recomendación',
                  emoji: '👥',
                  closable: true,
                ),
                SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Text('Blog',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                ),
                SizedBox(height: 120),
              ],
            ),
          ),
        ],
      ),

      // Bottom bar: 4 items
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _current,
        onTap: _onBottomTap,
        backgroundColor:
            Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        selectedItemColor:
            Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
        unselectedItemColor:
            Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note_outlined),
            label: 'Programar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt_outlined),
            label: 'Diagnosticar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy_outlined),
            label: 'Consultar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: 'Notifs',
          ),
        ],
      ),
    );
  }
}

class _TopIcon extends StatelessWidget {
  final IconData icon;
  final bool active;
  final Color? activeColor;
  final VoidCallback? onTap;

  const _TopIcon({
    required this.icon,
    this.active = false,
    this.activeColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active
        ? (activeColor ?? Theme.of(context).colorScheme.primary)
        : (Theme.of(context).brightness == Brightness.dark
            ? Colors.white70
            : Colors.black54);

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 6),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 3,
            width: 88,
            decoration: BoxDecoration(
              color: active ? color : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String emoji;
  final bool closable;

  const FeatureCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.emoji,
    this.closable = false,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final subColor =
        isLight ? Colors.black87.withOpacity(0.75) : Colors.white70;

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                title: Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    subtitle,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: subColor, height: 1.25),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isLight
                        ? const Color(0xFFF0F2F4)
                        : Colors.white.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Text(emoji, style: const TextStyle(fontSize: 22)),
                ),
                if (closable)
                  IconButton(
                    icon: Icon(Icons.close,
                        size: 18,
                        color: isLight ? Colors.black54 : Colors.white70),
                    onPressed: () {},
                    splashRadius: 18,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
