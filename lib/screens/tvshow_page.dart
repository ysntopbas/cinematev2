import 'dart:developer';
import 'package:cinematev2/providers/tvshow_provider.dart';
import 'package:cinematev2/widgets/grid_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TvshowPage extends StatefulWidget {
  const TvshowPage({super.key});

  @override
  State<TvshowPage> createState() => _TvshowPageState();
}

class _TvshowPageState extends State<TvshowPage> {
  final ScrollController _scrollController = ScrollController();

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
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Listenin sonuna yaklaşıldığında yeni filmler yükle
      _loadMoreTvShows();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popüler Diziler'),
      ),
      body: RefreshIndicator(
        onRefresh: () => _fetchTvShows(refresh: true),
        child: Consumer<TvshowProvider>(
          builder: (context, tvShowprovider, child) {
            return GridViewWidget(
              contents: tvShowprovider.popularTvshows,
              isLoading: tvShowprovider.isLoading,
              error: tvShowprovider.error,
              scrollController: _scrollController,
              hasMorePages: tvShowprovider.hasMorePages,
              isMovie: false,
              addWatchList: tvShowprovider.addTvshowWatchList,
            );
          },
        ),
      ),
    );
  }
}
