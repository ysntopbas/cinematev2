import 'package:cinematev2/configs/api_config.dart';
import 'package:flutter/material.dart';

class GridViewItem extends StatelessWidget {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  const GridViewItem({
    super.key,
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
  });

  @override
  Widget build(BuildContext context) {
    // if (index == movies.length) {
    //   // Son eleman yükleniyor göstergesi
    //   return const Center(
    //     child: Padding(
    //       padding: EdgeInsets.all(8.0),
    //       child: CircularProgressIndicator(),
    //     ),
    //   );
    // }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border:
            Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
              child: posterPath.isNotEmpty
                  ? Image.network(
                      '${ApiConfig.imageBaseUrl}$posterPath',
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
              title,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
