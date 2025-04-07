import 'dart:developer';
import 'package:cinematev2/providers/tvshow_provider.dart';
import 'package:cinematev2/widgets/grid_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/search_service.dart';
import '../models/tvshows_models.dart';

class TvshowPage extends StatefulWidget {
  const TvshowPage({super.key});

  @override
  State<TvshowPage> createState() => _TvshowPageState();
}

class _TvshowPageState extends State<TvshowPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final SearchService _searchService = SearchService();
  bool _isSearching = false;
  List<Tvshow> _searchResults = [];
  bool _isSearchLoading = false;
  String? _searchError;

  @override
  void initState() {
    super.initState();
    // Sayfa yüklendiğinde ilk filmleri çek
    Future.microtask(() => _fetchTvShows());

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
        _loadMoreTvShows();
      }
    }
  }

  Future<void> _fetchTvShows({bool refresh = false}) async {
    if (!mounted) return;

    try {
      await Provider.of<TvshowProvider>(context, listen: false)
          .fetchPopularTvshows(refresh: refresh);
    } catch (e) {
      log("Dizi sayfası hata: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Diziler yüklenirken bir hata oluştu: $e")),
        );
      }
    }
  }

  Future<void> _loadMoreTvShows() async {
    final tvshowprovider = Provider.of<TvshowProvider>(context, listen: false);
    if (!tvshowprovider.isLoading && tvshowprovider.hasMorePages) {
      await _fetchTvShows();
    }
  }

  Future<void> _searchTvShows(String query) async {
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
      final results = await _searchService.searchTvShows(query);
      setState(() {
        _searchResults = (results['results'] as List)
            .map((show) => Tvshow.fromJson(show))
            .toList();
        _isSearchLoading = false;
      });
    } catch (e) {
      log("Dizi arama hatası: $e");
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
                  hintText: 'Dizi ara...',
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _clearSearch,
                  ),
                ),
                onSubmitted: _searchTvShows,
              )
            : const Text('Popüler Diziler'),
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
            _isSearching ? Future.value() : _fetchTvShows(refresh: true),
        child: _isSearching
            ? _buildSearchResults()
            : Consumer<TvshowProvider>(
                builder: (context, tvShowprovider, child) {
                  return GridViewWidget(
                    contents: tvShowprovider.popularTvshows,
                    isLoading: tvShowprovider.isLoading,
                    error: tvShowprovider.error,
                    scrollController: _scrollController,
                    hasMorePages: tvShowprovider.hasMorePages,
                    isMovie: false,
                    addWatchList: tvShowprovider.addTvShowWatchList,
                    removeWatchList: tvShowprovider.removeTvShowWatchList,
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
              onPressed: () => _searchTvShows(_searchController.text),
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

    final tvshowProvider = Provider.of<TvshowProvider>(context, listen: false);
    return GridViewWidget(
      contents: _searchResults,
      isLoading: false,
      error: null,
      scrollController: _scrollController,
      hasMorePages: false,
      isMovie: false,
      addWatchList: tvshowProvider.addTvShowWatchList,
      removeWatchList: tvshowProvider.removeTvShowWatchList,
    );
  }
}
