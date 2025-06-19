import 'package:cinematev2/models/content_models.dart';
import 'package:cinematev2/widgets/grid_view_item.dart';
import 'package:flutter/material.dart';

class GridViewWidget extends StatelessWidget {
  final List<Content> contents;
  final bool isLoading;
  final String? error;
  final ScrollController? scrollController;
  final bool hasMorePages;
  final bool isMovie;
  final void Function(int id, String title) addWatchList;
  final void Function(int id) removeWatchList;
  final void Function(int id, String title, String type, String posterPath)?
      onFavoriteTap;
  final bool Function(int id)? isFavorite;

  const GridViewWidget({
    super.key,
    required this.contents,
    this.isLoading = false,
    this.error,
    this.scrollController,
    this.hasMorePages = true,
    this.isMovie = true,
    required this.addWatchList,
    required this.removeWatchList,
    this.onFavoriteTap,
    this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    if (contents.isEmpty && isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (contents.isEmpty && error != null) {
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
    if (contents.isEmpty) {
      return Center(
        child: Text(isMovie ? 'Film bulunamadı' : 'Dizi bulunamadı'),
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
      itemCount: contents.length + (isLoading && hasMorePages ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == contents.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final content = contents[index];

        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/detail',
              arguments: {
                'id': content.id,
                'isMovie': isMovie,
              },
            );
          },
          child: GridViewItem(
            id: content.id,
            title: content.title,
            posterPath: content.posterPath,
            isAdded: content.isAdded,
            isFavorite: isFavorite?.call(content.id) ?? false,
            isMovie: isMovie,
            onTap: () => addWatchList(content.id, content.title),
            onRemove: () => removeWatchList(content.id),
            onFavoriteTap: onFavoriteTap != null
                ? () => onFavoriteTap!(content.id, content.title,
                    isMovie ? 'movie' : 'tv', content.posterPath)
                : null,
          ),
        );
      },
    );
  }
}
