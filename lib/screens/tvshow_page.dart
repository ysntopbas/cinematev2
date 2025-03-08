import 'package:cinematev2/widgets/grid_view_widget.dart';
import 'package:flutter/material.dart';

class TvshowPage extends StatelessWidget {
  const TvshowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popüler Diziler'),
      ),
      body: GridViewWidget(movies: [],),
    );
  }
}
