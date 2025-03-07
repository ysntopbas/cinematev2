import 'package:cinematev2/widgets/grid_view_widget.dart';
import 'package:flutter/material.dart';

class MoviePage extends StatelessWidget {
  const MoviePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popüler Filmler'),
      ),
      body: GridViewWidget(),
    );
  }
}
