import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/watch_list_service.dart';
import '../services/ai_service.dart';
import '../providers/ai_recommendations_provider.dart';
import 'dart:convert';

class AiAdvicePage extends StatefulWidget {
  const AiAdvicePage({super.key});

  @override
  State<AiAdvicePage> createState() => _AiAdvicePageState();
}

class _AiAdvicePageState extends State<AiAdvicePage> {
  final WatchListService _watchListService = WatchListService();
  final AiService _aiService = AiService();
  bool _isWatchListEmpty = false;

  @override
  void initState() {
    super.initState();
    _checkWatchLists();
  }

  Future<void> _checkWatchLists() async {
    try {
      final movies = await _watchListService.getFetchWatchList('movie');
      final series = await _watchListService.getFetchWatchList('series');

      setState(() {
        _isWatchListEmpty = !(movies.isEmpty || series.isEmpty);
      });
    } catch (e) {
      setState(() {
        _isWatchListEmpty = false;
      });
    }
  }

  Future<void> _getRecommendations() async {
    final provider =
        Provider.of<AiRecommendationsProvider>(context, listen: false);
    provider.setLoading(true);

    try {
      // Film izleme listesi
      final movies = await _watchListService.getFetchWatchList('movie');
      // Dizi izleme listesi
      final series = await _watchListService.getFetchWatchList('series');

      // Film ve dizi adlarını tek bir listede birleştir
      final allContent = [
        ...movies.map((movie) => movie['title'] as String),
        ...series.map((serie) => serie['title'] as String),
      ];

      // Google AI Studio'dan öneriler al
      final recommendations = await _aiService.getRecommendations(allContent);
      provider.setRecommendations(recommendations);
    } catch (e) {
      provider.setLoading(false);
      if (!mounted) return; // Bu satırı context hatasını fixler
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata oluştu: $e')),
      );
    }
  }

  Widget _buildRecommendationsList() {
    final provider = Provider.of<AiRecommendationsProvider>(context);
    final recommendations = provider.recommendations;
    final watchedItems = provider.watchedItems;

    if (recommendations == null) return const SizedBox.shrink();

    try {
      final response =
          recommendations['candidates'][0]['content']['parts'][0]['text'];
      final cleanJson =
          response.replaceAll('```json\n', '').replaceAll('\n```', '');
      final recommendationsData = jsonDecode(cleanJson);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Önerilen Filmler',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...List<String>.from(recommendationsData['movies'])
              .map((movie) => ListTile(
                    leading: const Icon(Icons.movie),
                    title: Text(
                      movie,
                      style: TextStyle(
                        decoration: watchedItems[movie] == true
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    trailing: Checkbox(
                      value: watchedItems[movie] ?? false,
                      onChanged: (bool? value) => provider.toggleWatched(movie),
                    ),
                  )),
          const SizedBox(height: 16),
          const Text(
            'Önerilen Diziler',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...List<String>.from(recommendationsData['tv_shows'])
              .map((show) => ListTile(
                    leading: const Icon(Icons.monitor),
                    title: Text(
                      show,
                      style: TextStyle(
                        decoration: watchedItems[show] == true
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    trailing: Checkbox(
                      value: watchedItems[show] ?? false,
                      onChanged: (bool? value) => provider.toggleWatched(show),
                    ),
                  )),
        ],
      );
    } catch (e) {
      return Text('Öneriler yüklenirken hata oluştu: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AiRecommendationsProvider>(context);
    final isLoading = provider.isLoading;
    final showRecommendations = provider.showRecommendations;
    final canGetNewRecommendations = provider.canGetNewRecommendations;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cinemate Önerileri'),
      ),
      body: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: showRecommendations ? 100 : 200,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: showRecommendations ? 55 : 120,
                  height: showRecommendations ? 55 : 120,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/images/robot.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Cinemate AI Önerileri',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          if (showRecommendations)
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border:
                      Border.all(color: Theme.of(context).colorScheme.primary),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: _buildRecommendationsList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: _isWatchListEmpty
                  ? FilledButton(
                      onPressed: isLoading || !canGetNewRecommendations
                          ? null
                          : _getRecommendations,
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('Öneri Al'),
                    )
                  : const Text(
                      'Öneri almak için izleme listenize en az bir film ve bir dizi ekleyin',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
