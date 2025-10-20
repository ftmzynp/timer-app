import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart'; // ApiService importunu unutma

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String avatarId = "avatar_01.png"; // Varsayılan avatar
  bool acceptTerms = false;
  bool isLoading = false;

  final ApiService _apiService = ApiService();

  void _chooseAvatar() {
    final avatars = ["avatar_01.png", "avatar_02.png", "avatar_03.png"];

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Avatar Seç"),
        content: Wrap(
          spacing: 10,
          children: avatars
              .map(
                (a) => GestureDetector(
                  onTap: () {
                    setState(() => avatarId = a);
                    Navigator.pop(ctx);
                  },
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/avatars/$a"),
                    radius: 30,
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    if (!acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Devam etmek için koşulları kabul edin")),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Şifreler eşleşmiyor!")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await _apiService.registerUser(
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Kayıt başarılı: ${response['message'] ?? ''}")),
      );

      Navigator.pushReplacementNamed(context, "/login");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hata: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          // 🔹 Header SVG
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 300,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  SvgPicture.asset(
                    "assets/vectors/Vector.svg",
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    fit: BoxFit.fill,
                    colorFilter:
                        ColorFilter.mode(colorScheme.primary, BlendMode.srcIn),
                  ),
                  Positioned(
                    top: 90,
                    left: 20,
                    child: Text(
                      " Hesap \n Oluştur",
                      style: GoogleFonts.quicksand(
                        textStyle: theme.textTheme.headlineMedium?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 🔹 İçerik
          Column(
            children: [
              const SizedBox(height: 200),

              // Avatar seçimi
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: GestureDetector(
                  onTap: _chooseAvatar,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: colorScheme.surface,
                    child: CircleAvatar(
                      radius: 48,
                      backgroundImage: AssetImage("assets/avatars/$avatarId"),
                    ),
                  ),
                ),
              ),

              // Form
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration:
                              const InputDecoration(labelText: "E-posta"),
                          validator: (v) =>
                              v!.isEmpty ? "E-posta giriniz" : null,
                        ),
                        TextFormField(
                          controller: _usernameController,
                          decoration:
                              const InputDecoration(labelText: "Kullanıcı Adı"),
                          validator: (v) =>
                              v!.isEmpty ? "Kullanıcı adı giriniz" : null,
                        ),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration:
                              const InputDecoration(labelText: "Şifre"),
                          validator: (v) =>
                              v!.isEmpty ? "Şifre giriniz" : null,
                        ),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                              labelText: "Şifre (Tekrar)"),
                          validator: (v) =>
                              v!.isEmpty ? "Şifre tekrar giriniz" : null,
                        ),

                        Row(
                          children: [
                            Checkbox(
                              value: acceptTerms,
                              activeColor: colorScheme.primary,
                              onChanged: (v) =>
                                  setState(() => acceptTerms = v!),
                            ),
                            Expanded(
                              child: Text(
                                "Politika ve koşulları kabul ediyorum",
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // 🔹 Kayıt Ol Butonu
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            minimumSize: const Size(double.infinity, 55),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          onPressed: isLoading ? null : _registerUser,
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  "Kayıt Ol",
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: colorScheme.onPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),

                        const SizedBox(height: 20),

                        // 🔹 Login yönlendirme
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Zaten hesabın var mı? ",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, "/login");
                              },
                              child: Text(
                                "Giriş yap",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}