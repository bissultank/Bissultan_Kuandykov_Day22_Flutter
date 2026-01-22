import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/theme_provider.dart';
import 'screens/genre_screen.dart';

void main() async {
  // Инициализация Flutter bindings
  WidgetsFlutterBinding.ensureInitialized();

  // Создание и инициализация ThemeProvider
  final themeProvider = ThemeProvider();
  await themeProvider.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
      ],
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
      title: 'Game Selector',
      debugShowCheckedModeBanner: false,
      theme: themeProvider.themeData,
      home: const GenreScreen(),
    );
  }
}
