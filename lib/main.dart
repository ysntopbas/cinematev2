import 'package:cinematev2/firebase_options.dart';
import 'package:cinematev2/providers/auth_provider.dart';
import 'package:cinematev2/providers/home_page_provider.dart';
import 'package:cinematev2/providers/tvshow_provider.dart';
import 'package:cinematev2/screens/ai_advice_page.dart';
import 'package:cinematev2/screens/detail_page.dart';
import 'package:cinematev2/screens/favorites_page.dart';
import 'package:cinematev2/screens/home_page.dart';
import 'package:cinematev2/screens/login_page.dart';
import 'package:cinematev2/screens/movie_page.dart';
import 'package:cinematev2/screens/register_page.dart';
import 'package:cinematev2/screens/tvshow_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cinematev2/providers/movie_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'providers/ai_recommendations_provider.dart';
import 'providers/favorite_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => MovieProvider()),
        ChangeNotifierProvider(create: (context) => TvshowProvider()),
        ChangeNotifierProvider(create: (context) => HomePageProvider()),
        ChangeNotifierProvider(create: (_) => AiRecommendationsProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
      ],
      child:
          Consumer3<AuthProvider, AiRecommendationsProvider, FavoriteProvider>(
        builder: (context, authProvider, aiProvider, favoriteProvider, child) {
          // Provider'ları auth provider'a bağla
          authProvider.setAiProvider(aiProvider);
          authProvider.setFavoriteProvider(favoriteProvider);

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
              '/detail': (context) => const DetailPage(),
              '/recommendations': (context) => const AiAdvicePage(),
              '/favorites': (context) => const FavoritesPage(),
            },
          );
        },
      ),
    );
  }
}
