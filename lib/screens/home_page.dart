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
    String? watchList = "";
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
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'İzleme Listesi (Filmler)',
              style: GoogleFonts.roboto(
                fontSize: 24,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  if (watchList.isEmpty)
                    Center(
                      child: Text('Henüz izleme listenize film eklemediniz'),
                    )
                  else
                    Text('İzleme Listesi'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'İzleme Listesi (Diziler)',
              style: GoogleFonts.roboto(
                fontSize: 24,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  if (watchList.isEmpty)
                    Column(
                      children: [
                        Center(
                          child:
                              Text('Henüz izleme listenize dizi eklemediniz'),
                        ),
                      ],
                    )
                  else
                    Text('İzleme Listesi'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
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
              leading: const Icon(Icons.home),
              title: const Text('Anasayfa'),
              onTap: () {
                Navigator.pushNamed(context, '/home');
              },
            ),
            ListTile(
              leading: const Icon(Icons.movie),
              title: const Text('Popüler Filmler'),
              onTap: () {
                Navigator.pushNamed(context, '/movie');
              },
            ),
            ListTile(
              leading: const Icon(Icons.tv),
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
    );
  }
}
