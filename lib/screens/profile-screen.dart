import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Mock user data (backend’den gelecek)
  String avatarUrl = "https://i.pravatar.cc/150?img=8";
  final String username = "Sophia B."; // 🔹 değiştirilemez
  final TextEditingController emailController =
      TextEditingController(text: "sophia@example.com");
  final TextEditingController bioController =
      TextEditingController(text: "Computer science student at University");

  // Şifre alanları
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isEditing = false;
  bool showPasswordFields = false;

  void _saveProfile() {
    setState(() {
      isEditing = false;
      showPasswordFields = false;
    });

    // 🔹 Burada backend'e güncelleme isteği atabilirsin
    // örn: ApiService.updateProfile(email, bio, newPassword)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profil güncellendi ✅")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
                    // 🔹 Avatar değiştirme için image picker eklenebilir
                  }
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(avatarUrl),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Kullanıcı adı (sadece gösterim)
            Text(
              username,
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

            // Şifre değiştirme toggle
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
          ],
        ),
      ),
    );
  }
}