import 'package:flutter/material.dart';
import '../services/watch_list_service.dart';

class AiAdvicePage extends StatefulWidget {
  const AiAdvicePage({super.key});

  @override
  State<AiAdvicePage> createState() => _AiAdvicePageState();
}

class _AiAdvicePageState extends State<AiAdvicePage> {
  final WatchListService _watchListService = WatchListService();
  bool _isLoading = false;
  bool _showRecommendations = false;
  List<String> _watchlistContent = [];

  Future<void> _getWatchlistContent() async {
    setState(() {
      _isLoading = true;
    });

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

      setState(() {
        _watchlistContent = allContent;
        _showRecommendations = true;
        _isLoading = false;
      });
      
      // Burada Google AI Studio API'sine istek atılacak
      // TODO: Google AI Studio entegrasyonu
      
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata oluştu: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cinemate Önerileri'),
      ),
      body: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _showRecommendations ? 200 : 400,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: _showRecommendations ? 100 : 200,
                  height: _showRecommendations ? 100 : 200,
                  decoration: BoxDecoration(
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
                const SizedBox(height: 10),
                if (!_showRecommendations)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Cinemate AI, izleme geçmişinize ve tercihlerine göre önerilerde bulunur.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                const SizedBox(height: 10),
                if (!_isLoading && !_showRecommendations)
                  FilledButton(
                    onPressed: _getWatchlistContent,
                    child: const Text('Öneri Al'),
                  ),
                if (_isLoading)
                  const CircularProgressIndicator(),
              ],
            ),
          ),
          if (_showRecommendations)
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).colorScheme.primary ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'İzleme Listeniz',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Bu içerikler Google AI Studio\'ya gönderilecek:',
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _watchlistContent.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: const Icon(Icons.movie),
                            title: Text(_watchlistContent[index]),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
