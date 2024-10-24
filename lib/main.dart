import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/models/bottomnav_state.dart'; // Make sure this path is correct
import 'package:quran_app/screens/home.dart'; // Ensure you have a Home screen
import 'package:quran_app/models/surah_provider.dart'; // Import the SurahProvider

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => BottomNavProvider(), // For bottom navigation
        ),
        ChangeNotifierProvider(
          create: (_) => SurahProvider(), // For managing Surah data
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quran App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      home: const MyHomePage(), // Your home page widget
    );
  }
}