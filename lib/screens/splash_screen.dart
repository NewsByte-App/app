import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newsbites/bloc/auth_bloc.dart';
import 'package:newsbites/screens/authentication.dart';
import 'package:newsbites/screens/home_screen.dart';

class SplashScreen extends StatelessWidget {
  static String routeName = "/";
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedTextKit(
          animatedTexts: [
            TyperAnimatedText(
              'NewsBites.',
              textStyle: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    fontWeight: FontWeight.w800,
                    fontStyle: FontStyle.italic,
                    fontSize: 40,
                  ),
              speed: const Duration(milliseconds: 100),
            ),
          ],
          onFinished: () {
            Navigator.pushNamedAndRemoveUntil(
                context, LoginPage.routeName, (route) => false);
          },
          totalRepeatCount: 1,
          pause: const Duration(milliseconds: 1000),
          displayFullTextOnTap: true,
          stopPauseOnTap: true,
        ),
      ),
    );
  }
}
