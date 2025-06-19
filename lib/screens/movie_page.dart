import 'dart:developer';
import 'package:cinematev2/providers/movie_provider.dart';
import 'package:cinematev2/widgets/grid_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/search_service.dart';
import '../models/movie_models.dart';

class MoviePage extends StatefulWidget {
  const MoviePage({super.key});

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final SearchService _searchService = SearchService();
  bool _isSearching = false;
  List<Movie> _searchResults = [];
  bool _isSearchLoading = false;
  String? _searchError;

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
    _searchController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Listenin sonuna yaklaşıldığında yeni filmler yükle
      if (_isSearching) {
        // Arama sonuçları için sayfalama yok, bu yüzden bir şey yapmıyoruz
      } else {
        _loadMoreMovies();
      }
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

  Future<void> _searchMovies(String query) async {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
        _searchError = null;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _isSearchLoading = true;
      _searchError = null;
    });

    try {
      final results = await _searchService.searchMovies(query);
      setState(() {
        _searchResults = (results['results'] as List)
            .map((movie) => Movie.fromJson(movie))
            .toList();
        _isSearchLoading = false;
      });
    } catch (e) {
      log("Film arama hatası: $e");
      setState(() {
        _searchError = "Arama sırasında bir hata oluştu: $e";
        _isSearchLoading = false;
      });
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _isSearching = false;
      _searchResults = [];
      _searchError = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Film ara...',
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _clearSearch,
                  ),
                ),
                onSubmitted: _searchMovies,
              )
            : const Text('Popüler Filmler'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              if (_isSearching) {
                _clearSearch();
              } else {
                setState(() {
                  _isSearching = true;
                });
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            _isSearching ? Future.value() : _fetchMovies(refresh: true),
        child: _isSearching
            ? _buildSearchResults()
            : Consumer<MovieProvider>(
                builder: (context, movieProvider, child) {
                  return GridViewWidget(
                    contents: movieProvider.popularMovies,
                    isLoading: movieProvider.isLoading,
                    error: movieProvider.error,
                    scrollController: _scrollController,
                    hasMorePages: movieProvider.hasMorePages,
                    isMovie: true,
                    addWatchList: movieProvider.addMovieWatchList,
                    removeWatchList: movieProvider.removeMovieWatchList,
                    onFavoriteTap: movieProvider.toggleFavorite,
                    isFavorite: movieProvider.isFavorite,
                  );
                },
              ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_isSearchLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_searchError != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_searchError!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _searchMovies(_searchController.text),
              child: const Text('Tekrar Dene'),
            ),
          ],
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return const Center(
        child: Text('Sonuç bulunamadı'),
      );
    }

    final movieProvider = Provider.of<MovieProvider>(context, listen: false);
    return GridViewWidget(
      contents: _searchResults,
      isLoading: false,
      error: null,
      scrollController: _scrollController,
      hasMorePages: false,
      isMovie: true,
      addWatchList: movieProvider.addMovieWatchList,
      removeWatchList: movieProvider.removeMovieWatchList,
      onFavoriteTap: movieProvider.toggleFavorite,
      isFavorite: movieProvider.isFavorite,
    );
  }
}
