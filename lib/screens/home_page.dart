import 'package:cinematev2/providers/auth_provider.dart';
import 'package:cinematev2/providers/home_page_provider.dart';
import 'package:cinematev2/configs/api_config.dart';
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<HomePageProvider>(context, listen: false).fetchWatchLists();
      }
    });
  }

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
      drawer: _buildDrawer(context),
      body: RefreshIndicator(
        onRefresh: () => Provider.of<HomePageProvider>(context, listen: false)
            .fetchWatchLists(),
        child: Consumer<HomePageProvider>(
          builder: (context, homeProvider, child) {
            if (homeProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (homeProvider.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Hata: ${homeProvider.error}'),
                    ElevatedButton(
                      onPressed: () => homeProvider.fetchWatchLists(),
                      child: const Text('Tekrar Dene'),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
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
                        if (homeProvider.watchListMovies.isEmpty) ...[
                          Center(
                            child:
                                Text('Henüz izleme listenize film eklemediniz'),
                          ),
                          IconButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/movie');
                              },
                              icon: Icon(Icons.add_circle))
                        ] else
                          listViewMovie(homeProvider),
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
                        if (homeProvider.watchListTvshows.isEmpty) ...[
                          Column(
                            children: [
                              Center(
                                child: Text(
                                    'Henüz izleme listenize dizi eklemediniz'),
                              ),
                              IconButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/tvshow');
                                  },
                                  icon: Icon(Icons.add_circle))
                            ],
                          )
                        ] else
                          listViewTvShow(homeProvider),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  ListView listViewTvShow(HomePageProvider homeProvider) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: homeProvider.watchListTvshows.length,
      itemBuilder: (context, index) {
        final tvshow = homeProvider.watchListTvshows[index];
        return ListTile(
          leading: Container(
            width: 50,
            height: 75,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(
                  '${ApiConfig.imageBaseUrl}${tvshow.posterPath}',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(tvshow.title),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => homeProvider.removeTvshowFromWatchList(tvshow.id),
          ),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/detail',
              arguments: {
                'id': tvshow.id,
                'isMovie': false,
              },
            );
          },
        );
      },
    );
  }

  ListView listViewMovie(HomePageProvider homeProvider) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: homeProvider.watchListMovies.length,
      itemBuilder: (context, index) {
        final movie = homeProvider.watchListMovies[index];
        return ListTile(
          leading: Container(
            width: 50,
            height: 75,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(
                  '${ApiConfig.imageBaseUrl}${movie.posterPath}',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(movie.title),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => homeProvider.removeMovieFromWatchList(movie.id),
          ),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/detail',
              arguments: {
                'id': movie.id,
                'isMovie': true,
              },
            );
          },
        );
      },
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
