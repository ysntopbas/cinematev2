import 'package:cinematev2/firebase_options.dart';
import 'package:cinematev2/providers/auth_provider.dart';
import 'package:cinematev2/screens/home_page.dart';
import 'package:cinematev2/screens/login_page.dart';
import 'package:cinematev2/screens/movie_page.dart';
import 'package:cinematev2/screens/register_page.dart';
import 'package:cinematev2/screens/tvshow_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CineMate',
        theme: ThemeData(
            colorScheme: ColorScheme.light(
          primary: Colors.amber,
          secondary: Colors.grey[900]!,
          surface: Colors.grey[900]!,
          onSurface: Colors.amber,
          onPrimary: Colors.grey[900]!,
          onSecondary: Colors.amber,
        )),
        home: Consumer<AuthProvider>(
          builder: (context, value, child) {
            if (value.isAuthenticated) {
              return const HomePage();
            } else {
              return const LoginPage();
            }
          },
        ),
        routes: {
          '/register': (context) {
            return Consumer<AuthProvider>(
              builder: (context, value, child) {
                if (value.isAuthenticated) {
                  return const HomePage();
                } else {
                  return const RegisterPage();
                }
              },
            );
          },
          '/home': (context) => const HomePage(),
          '/movie': (context) => const MoviePage(),
          '/tvshow': (context) => const TvshowPage(),
        },
      ),
    );
  }
}
