import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final String currentRoute;

  const AppDrawer({
    super.key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    final String userName = "Sophia B.";
    final String avatarUrl = "https://i.pravatar.cc/150?img=2";
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget buildMenuItem({
      required String title,
      required IconData icon,
      required String route,
    }) {
      final bool isSelected = currentRoute == route;

      return Container(
        decoration: isSelected
            ? BoxDecoration(
                color: colorScheme.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              )
            : null,
        child: ListTile(
          leading: Icon(
            icon,
            color: isSelected ? colorScheme.primary : colorScheme.onSurface,
          ),
          title: Text(
            title,
            style: TextStyle(
              color: isSelected ? colorScheme.primary : colorScheme.onSurface,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          onTap: () {
            if (!isSelected) {
              Navigator.pushReplacementNamed(context, route);
            } else {
              Navigator.pop(context);
            }
          },
        ),
      );
    }

    return Drawer(
      backgroundColor: colorScheme.surface,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // 🔹 Header (üst-alt boşluk eklenmiş)
          Container(
            color: colorScheme.surface,
            padding: const EdgeInsets.only(top: 50, bottom: 16, left: 20, right: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "/profile");
              },
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 34,
                    backgroundImage: NetworkImage(avatarUrl),
                    backgroundColor: colorScheme.onPrimary,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Merhaba,",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        userName,
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

          // 🔹 İnce ayırıcı çizgi
          Divider(
            height: 0.5,
            thickness: 0.3,
            color: colorScheme.onSurface.withOpacity(0.1),
          ),

          // 🔹 Menü itemleri
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Column(
              children: [
                buildMenuItem(title: "Zamanlayıcı", icon: Icons.timer, route: "/home"),
                buildMenuItem(title: "Pomodoro", icon: Icons.access_time, route: "/pomodoro"),
                buildMenuItem(title: "Odalar", icon: Icons.room, route: "/rooms"),
                buildMenuItem(title: "İstatistikler", icon: Icons.bar_chart, route: "/stats"),
                buildMenuItem(title: "Ayarlar", icon: Icons.settings, route: "/settings"),
               
              ],
            ),
          ),
        ],
      ),
    );
  }
}