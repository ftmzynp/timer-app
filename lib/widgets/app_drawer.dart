import 'package:flutter/material.dart';
import 'package:timer/models/user_model.dart';
import '../services/auth_storage.dart';

class AppDrawer extends StatefulWidget {
  final String currentRoute;

  const AppDrawer({super.key, required this.currentRoute});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  AppUser? user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final u = await AuthStorage.getUser();
    setState(() => user = u);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Drawer(
      backgroundColor: colorScheme.surface,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.only(top: 50, bottom: 16, left: 20, right: 16),
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, "/profile"),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 34,
                    backgroundImage: user?.avatarId != null
                        ? AssetImage("assets/avatars/${user!.avatarId!}")
                        : const AssetImage("assets/avatars/avatar_01.png"),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Merhaba,",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        user?.username ?? "Misafir",
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Divider(color: colorScheme.onSurface.withOpacity(0.1)),

          // Menü itemleri
          _buildMenuItem(context, "Zamanlayıcı", Icons.timer, "/home"),
          _buildMenuItem(context, "Pomodoro", Icons.access_time, "/pomodoro"),
          _buildMenuItem(context, "Odalar", Icons.room, "/rooms"),
          _buildMenuItem(context, "İstatistikler", Icons.bar_chart, "/stats"),
          _buildMenuItem(context, "Ayarlar", Icons.settings, "/settings"),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Çıkış Yap"),
            onTap: () async {
              await AuthStorage.clearAll();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(context, "/login", (_) => false);
              }
            },
          )
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext ctx, String title, IconData icon, String route) {
    final theme = Theme.of(ctx);
    final colorScheme = theme.colorScheme;
    final bool isSelected = widget.currentRoute == route;

    return Container(
      decoration: isSelected
          ? BoxDecoration(
              color: colorScheme.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            )
          : null,
      child: ListTile(
        leading: Icon(icon, color: isSelected ? colorScheme.primary : colorScheme.onSurface),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? colorScheme.primary : colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: () {
          if (!isSelected) {
            Navigator.pushReplacementNamed(ctx, route);
          } else {
            Navigator.pop(ctx);
          }
        },
      ),
    );
  }
}