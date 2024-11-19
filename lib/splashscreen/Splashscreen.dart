import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:duancuoiky/Dangnhap.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Center(
        child:
            LottieBuilder.asset("assets/Lottie/Animation_1727750263803.json"),
      ),
      nextScreen: const Dangnhap(),
      splashIconSize: 400,
      backgroundColor: Colors.white,
      duration: 1500,
    );
  }
}
