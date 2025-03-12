import 'package:cinematev2/configs/api_config.dart';
import 'package:flutter/material.dart';

class GridViewItem extends StatefulWidget {
  final int id;
  final String title;
  final String posterPath;
  const GridViewItem({
    super.key,
    required this.id,
    required this.title,
    required this.posterPath,
  });

  @override
  State<GridViewItem> createState() => _GridViewItemState();
}

bool isStar = false;
bool isFavorite = false;

class _GridViewItemState extends State<GridViewItem> {
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

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: Theme.of(context).colorScheme.primary, width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(8)),
                  child: widget.posterPath.isNotEmpty
                      ? Image.network(
                          '${ApiConfig.imageBaseUrl}${widget.posterPath}',
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
                                value: loadingProgress.expectedTotalBytes !=
                                        null
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
                  widget.title,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: Column(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    isFavorite = !isFavorite;
                  });
                },
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      isStar = !isStar;
                    });
                  },
                  icon: Icon(
                    isStar ? Icons.star : Icons.star_border,
                    color: Theme.of(context).colorScheme.primary,
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
