import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newsbites/bloc/auth_bloc.dart';
import 'package:newsbites/bloc/news/news_bloc.dart';
import 'package:newsbites/bloc/theme/theme_bloc.dart';
import 'package:newsbites/bloc/theme/theme_event.dart';
import 'package:newsbites/screens/article_screen.dart';
import 'package:newsbites/screens/authentication.dart';
import 'package:newsbites/screens/feed_screen.dart';
import 'package:newsbites/screens/home_screen.dart';
import 'package:newsbites/screens/home_screen.dart';
import 'package:newsbites/screens/splash_screen.dart';
import 'package:newsbites/utils/shared_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenceUtils.init();
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(
            create: (context) => ThemeBloc()
              ..add(
                SetInitialTheme(),
              )),
        BlocProvider(create: (context) => NewsBloc()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeData>(
        builder: (context, themState) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: themState,
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            routes: {
              '/': (context) => const SplashScreen(),
              '/login': (context) => const LoginPage(),
              HomeScreen.routeName: (context) => const HomeScreen(),
              FeedScreen.routeName: (context) => const FeedScreen()
            },
          );
        },
      ),
    );
  }
}
