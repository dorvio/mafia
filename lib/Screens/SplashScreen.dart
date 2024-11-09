import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mafia/Screens/MenuView.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      backgroundColor: Colors.black,
        splash: Transform.scale(
          scale: 8.0,
          child: Lottie.asset('assets/animations/mafia_animation.json',
          ),
        ),
        nextScreen: const MenuView());
  }
}
