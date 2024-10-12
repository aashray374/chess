import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isVisible = true;

  @override
  void initState() {
    Timer(const Duration(milliseconds: 1000), (){
      setState(() {
        isVisible = !isVisible;
      });
      Timer(const Duration(milliseconds: 1000),(){
        Navigator.pushNamed(context, '/passNplay');
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      body: Center(
        child: AnimatedOpacity(
          duration:const Duration(seconds: 1),
          opacity: isVisible? 1.0:0.0,
          child: Image.asset("assets/images/logo.png", color: Colors.green[600], height: 200,width: 200,),
        ),
      ),
    );
  }
}