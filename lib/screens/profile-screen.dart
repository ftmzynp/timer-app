import 'package:flutter/material.dart';
import 'package:timer/models/user_model.dart';
import 'package:timer/services/auth_storage.dart';
import 'package:timer/services/api_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AppUser? user;
  bool isEditing = false;
  bool showPasswordFields = false;

  // Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final currentUser = await AuthStorage.getUser();
    if (currentUser != null) {
      setState(() {
        user = currentUser;
        emailController.text = currentUser.email;
        bioController.text = ""; // backend bio alanı eklenirse buraya yazılır
      });
    }
  }

  Future<void> _saveProfile() async {
    setState(() {
      isEditing = false;
      showPasswordFields = false;
    });

    // 🔹 Backend güncelleme (örnek)
    try {
      // şimdilik sadece UI mock
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profil güncellendi ✅")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Profil güncellenemedi: $e")),
      );
    }
  }

  Future<void> _logout() async {
    await AuthStorage.clearAll();
    if (mounted) {
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
        actions: [
          if (!isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() => isEditing = true);
              },
            ),
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveProfile,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar
            Center(
              child: GestureDetector(
                onTap: () {
                  if (isEditing) {
                    // 🔹 avatar değiştirilebilir (image picker eklenebilir)
                  }
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(
                    "assets/avatars/${user!.avatarId ?? "avatar_01.png"}",
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Kullanıcı adı
            Text(
              user!.username,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 20),

            // Email
            TextField(
              controller: emailController,
              enabled: isEditing,
              decoration: const InputDecoration(
                labelText: "E-posta",
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 16),

            // Bio
            TextField(
              controller: bioController,
              enabled: isEditing,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Biyografi",
                prefixIcon: Icon(Icons.person),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 20),

            // Şifre değiştir switch
            if (isEditing)
              SwitchListTile(
                title: const Text("Şifreyi değiştir"),
                value: showPasswordFields,
                onChanged: (val) {
                  setState(() => showPasswordFields = val);
                },
              ),

            // Şifre alanları
            if (isEditing && showPasswordFields) ...[
              TextField(
                controller: oldPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Eski Şifre",
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Yeni Şifre",
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Yeni Şifre (Tekrar)",
                  prefixIcon: Icon(Icons.lock_reset),
                ),
              ),
              const SizedBox(height: 20),
            ],

            if (isEditing)
              ElevatedButton.icon(
                onPressed: _saveProfile,
                icon: const Icon(Icons.check),
                label: const Text("Kaydet"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                ),
              ),

            const SizedBox(height: 30),

            // 🔹 Çıkış yap butonu
            ElevatedButton.icon(
              onPressed: _logout,
              icon: const Icon(Icons.logout),
              label: const Text("Çıkış Yap"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}