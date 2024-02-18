import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newsbyte/bloc/auth_bloc.dart';
import 'package:newsbyte/screens/authentication.dart';
import 'package:newsbyte/screens/home_screen.dart';
import 'package:newsbyte/screens/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://qnxpcuuueqqslgitjyzr.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFueHBjdXV1ZXFxc2xnaXRqeXpyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDc2MzQ0MTIsImV4cCI6MjAyMzIxMDQxMn0.QMY9Grt69meZjGKmQYoHglFvvZ6jiLZC086lY5Wq5sE',
  );
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: GoogleFonts.playfairDisplay().fontFamily,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginPage(),
          '/home': (context) => const HomeScreen()
        },
      ),
    );
  }
}
