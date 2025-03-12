import 'package:cinematev2/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CineMate',
            style: GoogleFonts.fleurDeLeah(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            )),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              context.read<AuthProvider>().logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'CineMate',
                      style: GoogleFonts.fleurDeLeah(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              ListTile(
                title: const Text('Anasayfa'),
                onTap: () {
                  Navigator.pushNamed(context, '/home');
                },
              ),
              ListTile(
                title: const Text('Popüler Filmler'),
                onTap: () {
                  Navigator.pushNamed(context, '/movie');
                },
              ),
              ListTile(
                title: const Text('Popüler Diziler'),
                onTap: () {
                  Navigator.pushNamed(context, '/tvshow');
                },
              ),
              Spacer(),
              Text(
                  textAlign: TextAlign.center,
                  'Hoşgeldiniz ${context.read<AuthProvider>().user?.email ?? 'boş'}'),
            ],
          ),
        ),
      ),
      body: Center(child: ListView.builder(itemBuilder: (context, index) {
        return ListTile(
          title: Text('Item $index'),
        );
      })),
    );
  }
}
