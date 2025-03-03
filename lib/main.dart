import 'package:cinematev2/firebase_options.dart';
import 'package:cinematev2/screens/login_page.dart';
import 'package:cinematev2/screens/register_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
    return MaterialApp(
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
      home: LoginPage(),
      routes: {
        '/register': (context) => const RegisterPage(),
      },
    );
  }
}
