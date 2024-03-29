import 'package:flutter/material.dart';
import 'package:memorizer/modules/game_/game_screen.dart';
import 'package:memorizer/modules/landing_page/landing_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.green,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      home: const Scaffold(
        body: LandingPage(),
      ),
    );
  }
}
