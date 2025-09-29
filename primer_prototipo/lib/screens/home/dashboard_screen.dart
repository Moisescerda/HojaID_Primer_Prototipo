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
      drawer: const AppDrawer(),

      appBar: AppBar(
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

          // ======= CONTENIDO: Comunidad =======
          const Expanded(child: _CommunityFeed()),
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
            label: 'Calendario',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt_outlined),
            label: 'Diagnosticar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy_outlined),
            label: 'Consulta',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: 'Notificaciones',
          ),
        ],
      ),
    );
  }
}

/* ===================== Feed de comunidad ===================== */

class _CommunityFeed extends StatefulWidget {
  const _CommunityFeed();

  @override
  State<_CommunityFeed> createState() => _CommunityFeedState();
}

class _CommunityFeedState extends State<_CommunityFeed> {
  final List<_Post> _posts = [
    _Post(
      user: 'Ana',
      crop: 'Frijol Negro',
      text:
          'Aparecieron manchas amarillas en hojas jóvenes. ¿Podría ser roya? ¿Qué recomiendan?',
      imageUrl:
          'https://images.unsplash.com/photo-1501004318641-b39e6451bec6?q=80&w=1200&auto=format&fit=crop',
      minutesAgo: 12,
      likes: 4,
      comments: ['Podría ser roya temprana', 'Manda foto del envés'],
    ),
    _Post(
      user: 'Carlos',
      crop: 'Frijol Pinto',
      text:
          'Después de la lluvia noté mildiu en parches. Subo foto. ¿Sirve alternar con cobre?',
      imageUrl:
          'https://images.unsplash.com/photo-1524593979632-7217e3f3b21d?q=80&w=1200&auto=format&fit=crop',
      minutesAgo: 35,
      likes: 8,
      comments: ['Sí, alterna con sistémico', 'Mejor evalúa severidad primero'],
    ),
    _Post(
      user: 'Moisés',
      crop: 'Parcela mixta',
      text:
          'Consejo: revisen el borde del lote, ahí empezó la mosca blanca en mi parcela.',
      imageUrl:
          'https://images.unsplash.com/photo-1593011954956-b7ca1f3b4f13?q=80&w=1200&auto=format&fit=crop',
      minutesAgo: 60,
      likes: 2,
      comments: ['Gracias por el tip 🙌'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 100),
      itemCount: _posts.length + 1,
      itemBuilder: (ctx, i) {
        if (i == 0) {
          // Tarjeta para crear publicación
          return _ComposerCard(
            onTap: () => Navigator.pushNamed(context, Routes.capture),
          );
        }
        final p = _posts[i - 1];
        return _PostCard(
          post: p,
          onLike: () => setState(() => p.likes++),
          onComment: () => _openCommentsSheet(p),
        );
      },
    );
  }

  void _openCommentsSheet(_Post post) async {
    final controller = TextEditingController();
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) {
        final insets = MediaQuery.of(ctx).viewInsets.bottom;
        return Padding(
          padding: EdgeInsets.only(bottom: insets),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text('Comentarios (${post.comments.length})',
                      style: const TextStyle(fontWeight: FontWeight.w800)),
                  subtitle: Text('${post.user} • ${post.crop}'),
                ),
                Flexible(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    shrinkWrap: true,
                    itemBuilder: (_, i) =>
                        Text('• ${post.comments[i]}', style: const TextStyle(height: 1.3)),
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemCount: post.comments.length,
                  ),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                            hintText: 'Escribe una respuesta…',
                          ),
                          minLines: 1,
                          maxLines: 3,
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: () {
                          final t = controller.text.trim();
                          if (t.isEmpty) return;
                          setState(() => post.comments.add(t));
                          Navigator.pop(ctx);
                        },
                        child: const Icon(Icons.send_rounded),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ComposerCard extends StatelessWidget {
  final VoidCallback onTap;
  const _ComposerCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final sub = isLight ? Colors.black54 : Colors.white70;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          child: Row(
            children: [
              const CircleAvatar(child: Icon(Icons.person)),
              const SizedBox(width: 12),
              Expanded(
                child: Text('Comparte una foto o pregunta a la comunidad…',
                    style: TextStyle(color: sub)),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: onTap,
                icon: const Icon(Icons.add_a_photo_outlined, size: 18),
                label: const Text('Publicar'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final _Post post;
  final VoidCallback onLike;
  final VoidCallback onComment;

  const _PostCard({
    required this.post,
    required this.onLike,
    required this.onComment,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final sub = isLight ? Colors.black54 : Colors.white70;
    final bubble =
        isLight ? const Color(0xFFF0F2F4) : Colors.white.withValues(alpha: 0.06);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: .15),
              child: Text(post.user.characters.first.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.w800)),
            ),
            title: Text('${post.user} • ${post.crop}',
                style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Text('${post.minutesAgo} min', style: TextStyle(color: sub)),
            trailing: IconButton(
              icon: const Icon(Icons.more_horiz),
              onPressed: () {},
            ),
          ),

          // Texto
          if (post.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
              child: Text(post.text, style: const TextStyle(height: 1.25)),
            ),

          // Imagen
          if (post.imageUrl != null)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.zero, bottom: Radius.zero),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  post.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: bubble,
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image_outlined, size: 48),
                  ),
                  loadingBuilder: (ctx, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: bubble,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ),

          // Acciones
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 2, 6, 6),
            child: Row(
              children: [
                _ActionChip(
                  icon: Icons.thumb_up_alt_outlined,
                  label: '${post.likes} Me gusta',
                  onTap: onLike,
                ),
                const SizedBox(width: 6),
                _ActionChip(
                  icon: Icons.mode_comment_outlined,
                  label: '${post.comments.length} Responder',
                  onTap: onComment,
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.share_outlined),
                  onPressed: () {},
                  tooltip: 'Compartir',
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionChip({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final bg = isLight ? const Color(0xFFF0F2F4) : Colors.white.withValues(alpha: 0.06);

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              Icon(icon, size: 18),
              const SizedBox(width: 6),
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

/* ===================== Soporte UI existente ===================== */

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

/* ===================== Modelo simple de Post ===================== */

class _Post {
  final String user;
  final String crop;
  final String text;
  final String? imageUrl;
  final int minutesAgo;
  int likes;
  final List<String> comments;

  _Post({
    required this.user,
    required this.crop,
    required this.text,
    required this.imageUrl,
    required this.minutesAgo,
    this.likes = 0,
    List<String>? comments,
  }) : comments = comments ?? [];
}
