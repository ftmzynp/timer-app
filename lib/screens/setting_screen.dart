import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../themes/theme_provider.dart';
import '../widgets/app_drawer.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ayarlar"),
        centerTitle: true,
      ),
      drawer: const AppDrawer(currentRoute: "/settings"),
      body: ListView(
        children: [
          // ---------- Tema ----------
          ListTile(
            title: const Text("Tema"),
            subtitle: Text(themeProvider.isDark ? "Karanlık" : "Aydınlık"),
            trailing: Switch(
              value: themeProvider.isDark,
              onChanged: (_) => themeProvider.toggleTheme(),
            ),
          ),
          const Divider(),

          // ---------- Bildirimler ----------
          SwitchListTile(
            title: const Text("Bildirimler"),
            subtitle: const Text("Oturum bitiminde uyarı al"),
            value: notificationsEnabled,
            onChanged: (val) {
              setState(() => notificationsEnabled = val);
              // Burada backend veya local notification bağlayabilirsin
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(val
                      ? "Bildirimler açıldı"
                      : "Bildirimler kapatıldı"),
                ),
              );
            },
          ),
          const Divider(),

          // ---------- İstatistikler ----------
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text("İstatistikleri Sıfırla"),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("İstatistikler sıfırlandı")),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.restore, color: Colors.blue),
            title: const Text("Verileri Geri Yükle"),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Veriler geri yüklendi")),
              );
            },
          ),
          const Divider(),

          // ---------- Geri Bildirim ----------
          ListTile(
            leading: const Icon(Icons.feedback, color: Colors.orange),
            title: const Text("Geri Bildirim Gönder"),
            onTap: () {
              // mailto veya feedback sayfası açabilirsin
            },
          ),
          const Divider(),

          // ---------- Hakkında ----------
          ListTile(
            leading: const Icon(Icons.info, color: Colors.green),
            title: const Text("Hakkında"),
            subtitle: const Text("Pomodoro & İstatistik Uygulaması\nv1.0.0"),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: "Pomodoro & Stats",
                applicationVersion: "1.0.0",
                applicationLegalese: "© 2025 Tüm Hakları Saklıdır",
              );
            },
          ),
        ],
      ),
    );
  }
}