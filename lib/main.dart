import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'themes/theme_provider.dart';
import 'routes.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 🔹 bunu ekle
  await dotenv.load(fileName: ".env");

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Timer App',
      theme: themeProvider.theme,
      initialRoute: AppRoutes.register, // ilk test için Register açılacak
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}