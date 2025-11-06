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

  // Get unified ranking list with all movies ordered by category priority
  // Good movies first (highest priority), then Okay, then Bad (lowest priority)
  List<Map<String, dynamic>> get unifiedRankingList {
    List<Map<String, dynamic>> allMovies = [];
    int relativePosition = 0;
    
    // Add Good movies
    for (var movie in _goodMovies) {
      allMovies.add({
        'movie': movie,
        'numericalRating': calculateNumericalRating('Good', relativePosition, true),
      });
      relativePosition++;
    }
    
    // Add Okay movies
    for (var movie in _okayMovies) {
      relativePosition = 0;
      allMovies.add({
        'movie': movie,
        'numericalRating': calculateNumericalRating('Okay', relativePosition, true),
      });
      relativePosition++;
    }
    
    // Add Bad movies
    for (var movie in _badMovies) {
      relativePosition = 0;
      allMovies.add({
        'movie': movie,
        'numericalRating': calculateNumericalRating('Bad', relativePosition, true),
      });
      relativePosition++;
    }
    
    return allMovies;
  }

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

  // Remove a movie from all lists
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

  // Calculate the unified rank for a movie at a given position in a category
  // Returns 1-indexed rank in the unified ranking list
  int calculateUnifiedRank(String category, int position) {
    int baseRank = 0;
    
    // Calculate base rank based on category
    switch (category.toLowerCase()) {
      case 'good':
        // Good movies start at rank 1
        baseRank = 0;
        break;
      case 'okay':
        // Okay movies come after all Good movies
        baseRank = _goodMovies.length;
        break;
      case 'bad':
        // Bad movies come after all Good and Okay movies
        baseRank = _goodMovies.length + _okayMovies.length;
        break;
      default:
        return 0;
    }
    
    // Add the position within the category (1-indexed)
    return baseRank + position + 1;
  }

  double calculateNumericalRating(String category, int position, bool isAdded) {
    double numericalRating = 10.0;

    int increment = 0;
    if (!isAdded) increment = 1;

    // Calculate rating based on
    switch (category.toLowerCase()) {
      case 'good':
        double interval = (10.0 - 6.7) / (_goodMovies.length + increment);
        numericalRating = numericalRating - (interval * position);
        break;
      case 'okay':
        double interval = (6.7 - 3.3) / (_okayMovies.length + increment);
        numericalRating = 6.7 - (interval * position);
        break;
      case 'bad':
        double interval = 3.3 / (_badMovies.length + increment);
        numericalRating = 3.3 - (interval * position);
        break;
      default:
        return 0;
    }
    
    // Add the position within the category (1-indexed)
    return numericalRating;
  }
}
