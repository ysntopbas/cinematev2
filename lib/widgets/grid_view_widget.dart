import 'package:cinematev2/configs/api_config.dart';
import 'package:cinematev2/models/movie_models.dart';
import 'package:flutter/material.dart';

class GridViewWidget extends StatelessWidget {
  final List<Movie> movies;
  final bool isLoading;
  final String? error;
  final ScrollController? scrollController;
  final bool hasMorePages;

  const GridViewWidget({
    super.key,
    required this.movies,
    this.isLoading = false,
    this.error,
    this.scrollController,
    this.hasMorePages = true,
  });

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty && isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (movies.isEmpty && error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hata: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Yeniden yükleme işlemi için bir callback eklenebilir
              },
              child: const Text('Tekrar Dene'),
            ),
          ],
        ),
      );
    }

    if (movies.isEmpty) {
      return const Center(
        child: Text('Film bulunamadı'),
      );
    }

    return GridView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.7,
      ),
      itemCount: movies.length + (isLoading && hasMorePages ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == movies.length) {
          // Son eleman yükleniyor göstergesi
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        final movie = movies[index];
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  child: movie.posterPath.isNotEmpty
                      ? Image.network(
                          '${ApiConfig.imageBaseUrl}${movie.posterPath}',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.movie,
                              size: 120,
                              color: Theme.of(context).colorScheme.primary,
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        )
                      : Icon(
                          Icons.movie,
                          size: 120,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                ),
              ),
              Divider(
                color: Theme.of(context).colorScheme.primary,
                height: 1,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  movie.title,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
