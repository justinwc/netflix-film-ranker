import 'package:flutter/foundation.dart';
import '../Model/simple_movie.dart';

class UserRatingState extends ChangeNotifier {
  // Three separate lists for different ratings
  List<SimpleMovie> _goodMovies = [];
  List<SimpleMovie> _okayMovies = [];
  List<SimpleMovie> _badMovies = [];

  // Getters for accessing the lists
  List<SimpleMovie> get goodMovies => List.unmodifiable(_goodMovies);
  List<SimpleMovie> get okayMovies => List.unmodifiable(_okayMovies);
  List<SimpleMovie> get badMovies => List.unmodifiable(_badMovies);

  // Get total count of rated movies
  int get totalRatedMovies => _goodMovies.length + _okayMovies.length + _badMovies.length;

  // Add a movie to the appropriate rating list
  void addRating(SimpleMovie movie, String rating) {
    // First, remove the movie from any existing list (in case user re-rates)
    _removeFromAllLists(movie.id);

    // Add to the appropriate list based on rating
    switch (rating.toLowerCase()) {
      case 'good':
        _goodMovies.add(movie);
        print('✅ Added "${movie.title}" to GOOD movies list');
        print('📊 Good movies count: ${_goodMovies.length}');
        break;
      case 'okay':
        _okayMovies.add(movie);
        print('⚖️ Added "${movie.title}" to OKAY movies list');
        print('📊 Okay movies count: ${_okayMovies.length}');
        break;
      case 'bad':
        _badMovies.add(movie);
        print('❌ Added "${movie.title}" to BAD movies list');
        print('📊 Bad movies count: ${_badMovies.length}');
        break;
      default:
        print('⚠️ Invalid rating: $rating');
        return;
    }

    // Notify listeners that the state has changed
    notifyListeners();
    
    // Print current state for debugging
    printCurrentState();
  }

  // Remove a movie from all lists
  void _removeFromAllLists(int movieId) {
    _goodMovies.removeWhere((movie) => movie.id == movieId);
    _okayMovies.removeWhere((movie) => movie.id == movieId);
    _badMovies.removeWhere((movie) => movie.id == movieId);
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
      print('🗑️ Removed movie ID $movieId from GOOD movies');
      wasRemoved = true;
    }
    if (_okayMovies.any((movie) => movie.id == movieId)) {
      _okayMovies.removeWhere((movie) => movie.id == movieId);
      print('🗑️ Removed movie ID $movieId from OKAY movies');
      wasRemoved = true;
    }
    if (_badMovies.any((movie) => movie.id == movieId)) {
      _badMovies.removeWhere((movie) => movie.id == movieId);
      print('🗑️ Removed movie ID $movieId from BAD movies');
      wasRemoved = true;
    }

    if (wasRemoved) {
      notifyListeners();
      printCurrentState();
    } else {
      print('⚠️ Movie ID $movieId was not found in any rating list');
    }
  }

  // Clear all ratings
  void clearAllRatings() {
    _goodMovies.clear();
    _okayMovies.clear();
    _badMovies.clear();
    print('🧹 Cleared all movie ratings');
    notifyListeners();
    printCurrentState();
  }

  // Print current state for debugging
  void printCurrentState() {
    print('📋 Current Rating State:');
    print('   Good movies (${_goodMovies.length}): ${_goodMovies.map((m) => m.title).toList()}');
    print('   Okay movies (${_okayMovies.length}): ${_okayMovies.map((m) => m.title).toList()}');
    print('   Bad movies (${_badMovies.length}): ${_badMovies.map((m) => m.title).toList()}');
    print('   Total rated: $totalRatedMovies movies');
    print('---');
  }
}
