// import 'package:chess/screens/splash_screen.dart';
import 'package:chess/game_logic/game_board.dart';
import 'package:chess/screens/splash_screen.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
    '/': (context) =>const SplashScreen(),
    '/passNplay' : (context) => const GameBoard(),
  },
    );
  }
}