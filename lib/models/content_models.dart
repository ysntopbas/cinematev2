abstract class Content {
  final int id;
  final String title;
  final String posterPath;
  bool isAdded;

  Content({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.isAdded,
  });
}
