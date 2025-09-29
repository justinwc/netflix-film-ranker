class SimpleMovie {
  final int id;
  final String title;
  final String posterPath;
  final String releaseDate;
  final double? voteAverage;
  final String overview;

  SimpleMovie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.releaseDate,
    this.voteAverage,
    required this.overview,
  });

  // Helper method to get year from release date
  String get year {
    try {
      return releaseDate.split('-')[0];
    } catch (e) {
      return 'Unknown';
    }
  }

  // Helper method to get full image URL
  String get fullPosterUrl {
    return "https://image.tmdb.org/t/p/w500$posterPath";
  }
}
