import 'package:flutter/foundation.dart';

class RatedMovie {
  final int id;
  final String title;
  final String posterPath;
  final String releaseDate;
  final double? voteAverage;
  final String overview;

  RatedMovie({
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

class UserRatingState extends ChangeNotifier {
  // Three separate lists for different ratings
  List<RatedMovie> _goodMovies = [];
  List<RatedMovie> _okayMovies = [];
  List<RatedMovie> _badMovies = [];

  // Getters for accessing the lists
  List<RatedMovie> get goodMovies => List.unmodifiable(_goodMovies);
  List<RatedMovie> get okayMovies => List.unmodifiable(_okayMovies);
  List<RatedMovie> get badMovies => List.unmodifiable(_badMovies);

  // Get total count of rated movies
  int get totalRatedMovies => _goodMovies.length + _okayMovies.length + _badMovies.length;

  // Add a movie to the appropriate rating list
  void addRating(RatedMovie movie, String rating) {
    // First, remove the movie from any existing list (in case user re-rates)
    removeFromAllLists(movie.id);

    // Add to the appropriate list based on rating
    switch (rating.toLowerCase()) {
      case 'good':
        _goodMovies.add(movie);
        break;
      case 'okay':
        _okayMovies.add(movie);
        break;
      case 'bad':
        _badMovies.add(movie);
        break;
      default:
        return;
    }

    // Notify listeners that the state has changed
    notifyListeners();
  }

  // Remove a movie from all lists (public for Beli ranking service)
  void removeFromAllLists(int movieId) {
    _goodMovies.removeWhere((movie) => movie.id == movieId);
    _okayMovies.removeWhere((movie) => movie.id == movieId);
    _badMovies.removeWhere((movie) => movie.id == movieId);
  }

  // Insert a movie at a specific position in the good movies list
  void insertGoodMovieAtPosition(RatedMovie movie, int position) {
    removeFromAllLists(movie.id); // Remove from all lists first
    _goodMovies.insert(position, movie);
    notifyListeners();
  }

  // Insert a movie at a specific position in the okay movies list
  void insertOkayMovieAtPosition(RatedMovie movie, int position) {
    removeFromAllLists(movie.id); // Remove from all lists first
    _okayMovies.insert(position, movie);
    notifyListeners();
  }

  // Insert a movie at a specific position in the bad movies list
  void insertBadMovieAtPosition(RatedMovie movie, int position) {
    removeFromAllLists(movie.id); // Remove from all lists first
    _badMovies.insert(position, movie);
    notifyListeners();
  }

  // Check if a movie is already rated and return its rating
  String? getMovieRating(int movieId) {
    if (_goodMovies.any((movie) => movie.id == movieId)) return 'Good';
    if (_okayMovies.any((movie) => movie.id == movieId)) return 'Okay';
    if (_badMovies.any((movie) => movie.id == movieId)) return 'Bad';
    return null;
  }

  // Check if a movie is rated
  bool isMovieRated(int movieId) {
    return _goodMovies.any((movie) => movie.id == movieId) || 
           _okayMovies.any((movie) => movie.id == movieId) || 
           _badMovies.any((movie) => movie.id == movieId);
  }

  // Remove a specific rating
  void removeRating(int movieId) {
    bool wasRemoved = false;
    
    if (_goodMovies.any((movie) => movie.id == movieId)) {
      _goodMovies.removeWhere((movie) => movie.id == movieId);
      wasRemoved = true;
    }
    if (_okayMovies.any((movie) => movie.id == movieId)) {
      _okayMovies.removeWhere((movie) => movie.id == movieId);
      wasRemoved = true;
    }
    if (_badMovies.any((movie) => movie.id == movieId)) {
      _badMovies.removeWhere((movie) => movie.id == movieId);
      wasRemoved = true;
    }

    if (wasRemoved) {
      notifyListeners();
    }
  }

  // Clear all ratings
  void clearAllRatings() {
    _goodMovies.clear();
    _okayMovies.clear();
    _badMovies.clear();
    notifyListeners();
  }
}
