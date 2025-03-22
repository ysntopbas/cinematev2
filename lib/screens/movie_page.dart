import 'package:cinematev2/providers/movie_provider.dart';
import 'package:cinematev2/widgets/grid_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:developer';

class MoviePage extends StatefulWidget {
  const MoviePage({super.key});

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Sayfa yüklendiğinde ilk filmleri çek
    Future.microtask(() => _fetchMovies());

    // Scroll controller'a listener ekle
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Listenin sonuna yaklaşıldığında yeni filmler yükle
      _loadMoreMovies();
    }
  }

  Future<void> _fetchMovies({bool refresh = false}) async {
    if (!mounted) return;

    try {
      await Provider.of<MovieProvider>(context, listen: false)
          .fetchPopularMovies(refresh: refresh);
    } catch (e) {
      log("Film sayfası hata: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Filmler yüklenirken bir hata oluştu: $e")),
        );
      }
    }
  }

  Future<void> _loadMoreMovies() async {
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);
    if (!movieProvider.isLoading && movieProvider.hasMorePages) {
      await _fetchMovies();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popüler Filmler'),
      ),
      body: RefreshIndicator(
        onRefresh: () => _fetchMovies(refresh: true),
        child: Consumer<MovieProvider>(
          builder: (context, movieProvider, child) {
            return GridViewWidget(
              contents: movieProvider.popularMovies,
              isLoading: movieProvider.isLoading,
              error: movieProvider.error,
              scrollController: _scrollController,
              hasMorePages: movieProvider.hasMorePages,
              addWatchList: movieProvider.addMovieWatchList,
              removeWatchList: movieProvider.removeMovieWatchList,
            );
          },
        ),
      ),
    );
  }
}
