import 'package:cinematev2/configs/api_config.dart';
import 'package:cinematev2/services/movie_service.dart';
import 'package:cinematev2/services/tvshow_service.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final MovieService _movieService = MovieService();
  final TvshowService _tvshowService = TvshowService();
  dynamic _content;
  bool _isLoading = true;
  String? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadContent();
  }

  Future<void> _loadContent() async {
    try {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final int id = args['id'];
      final bool isMovie = args['isMovie'];

      if (isMovie) {
        _content = await _movieService.fetchDetailMovies(id);
      } else {
        _content = await _tvshowService.fetchDetailMovies(id);
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Hata: $_error')),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(_content.title),
              background: _content.backdropPath != null
                  ? Image.network(
                      '${ApiConfig.imageBaseUrl}${_content.backdropPath}',
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_content.tagline != null && _content.tagline!.isNotEmpty)
                    Text(
                      _content.tagline!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    _content.overview ?? 'Açıklama bulunmuyor',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow('Orijinal Dil:', _content.originalLanguage ?? ''),
                  _buildInfoRow('Yayın Tarihi:', _content.firstAirDate ?? ''),
                  _buildInfoRow('Puan:', '${_content.voteAverage ?? 0}/10'),
                  _buildInfoRow('Oy Sayısı:', '${_content.voteCount ?? 0}'),
                  _buildInfoRow('Durum:', _content.status ?? ''),
                  if (_content.numberofEpisodes != null)
                    _buildInfoRow('Bölüm Sayısı:', '${_content.numberofEpisodes}'),
                  if (_content.numberofSeasons != null)
                    _buildInfoRow('Sezon Sayısı:', '${_content.numberofSeasons}'),
                  if (_content.genres != null && _content.genres!.isNotEmpty)
                    _buildInfoRow('Türler:', _content.getGenresAsString()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
