import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart'; // ApiService dosyan nerede ise import et

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;

  final ApiService _apiService = ApiService();

  Future<void> _loginUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final response = await _apiService.loginUser(
        email: _emailController.text, // Backend login email'i zorunlu tutmuyorsa boş geçilebilir
        password: _passwordController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ Giriş başarılı: ${response['message'] ?? ''}")),
      );

      // 🔹 Örneğin ana sayfaya yönlendir
      Navigator.pushReplacementNamed(context, "/home");

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Giriş hatası: $e")),
      );
      debugPrint("❌ Login error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _loginWithGoogle() {
    // Google Auth entegrasyonu
    debugPrint("Google ile giriş yapılacak...");
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
                    colorFilter: ColorFilter.mode(
                      colorScheme.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                  Positioned(
                    top: 90,
                    left: 30,
                    child: Text(
                      "Giriş\nYap",
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
              const SizedBox(height: 400),

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
                          decoration: InputDecoration(
                            labelText: "Mail Adresi",
                            labelStyle: TextStyle(color: colorScheme.onSurface),
                          ),
                          validator: (v) =>
                              v!.isEmpty ? "Mailinizi giriniz" : null,
                        ),

                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Şifre",
                            labelStyle: TextStyle(color: colorScheme.onSurface),
                          ),
                          validator: (v) => v!.isEmpty ? "Şifre giriniz" : null,
                        ),

                        const SizedBox(height: 60),

                        // 🔹 Giriş Yap Butonu
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            minimumSize: const Size(double.infinity, 55),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          onPressed: isLoading ? null : _loginUser,
                          child: isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  "Giriş Yap",
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: colorScheme.onPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),

                        const SizedBox(height: 20),

                        // 🔹 Google ile giriş
                        IconButton(
                          onPressed: _loginWithGoogle,
                          icon: Icon(
                            Icons.g_mobiledata,
                            size: 40,
                            color: colorScheme.primary,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // 🔹 Kayıt Ol Linki
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Hesabın yok mu? ",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, "/register");
                              },
                              child: Text(
                                "Kayıt Ol",
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