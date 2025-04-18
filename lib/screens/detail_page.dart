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
  bool _isMovie = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadContent();
  }

  Future<void> _loadContent() async {
    try {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final int id = args['id'];
      _isMovie = args['isMovie'];

      if (_isMovie) {
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
              title: Text(_content.title,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        blurRadius: 8,
                      )
                    ],
                  )),
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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 120,
                        height: 180,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: NetworkImage(
                                '${ApiConfig.imageBaseUrl}${_content.posterPath}',
                              ),
                              fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  '${(_content.voteAverage ?? 0).toStringAsFixed(1)}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Text(
                                  '(${_content.voteCount ?? 0} oy)',
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              _isMovie
                                  ? 'Çıkış Tarihi: ${_content.releaseDate}'
                                  : 'İlk Yayın Tarihi: ${_content.firstAirDate}',
                            ),
                            Text(_isMovie
                                ? 'Filmin Orjinal Dili : ${_content.originalLanguage}'
                                : 'Dizinin Orjinal Dili : ${_content.originalLanguage}'),
                            if (!_isMovie) ...[
                              Text('Durum: ${_content.status}'),
                              Text(
                                  'Bölüm Sayısı: ${_content.numberofEpisodes}'),
                              Text('Sezon Sayısı: ${_content.numberofSeasons}'),
                            ]
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_content.genres != null && _content.genres!.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      children: _content.genres!.map<Widget>((genre) {
                        return Chip(
                          label: Text(
                            genre['name'],
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary),
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    'Genel Bakış',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _content.overview ?? 'Açıklama bulunmuyor',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
