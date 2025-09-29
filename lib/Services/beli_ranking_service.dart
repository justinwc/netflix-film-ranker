import 'package:flutter/material.dart';
import '../Providers/user_rating_state.dart';
import '../Widgets/movie_comparison_dialog.dart';

class BeliRankingService {
  // Binary search to find the correct position for a new movie in any category
  static Future<int> findMoviePosition({
    required BuildContext context,
    required RatedMovie newMovie,
    required List<RatedMovie> existingMovies,
    required String category,
  }) async {
    if (existingMovies.isEmpty) {
      return 0; // First movie goes at position 0
    }

    if (existingMovies.length == 1) {
      // Compare with the single existing movie
      final existingMovie = existingMovies[0];
      final preferred = await _showComparisonDialog(
        context: context,
        newMovie: newMovie,
        existingMovie: existingMovie,
        category: category,
      );
      
      return preferred == newMovie ? 0 : 1;
    }

    // Binary search through the list
    int left = 0;
    int right = existingMovies.length - 1;
    
    while (left <= right) {
      int mid = (left + right) ~/ 2;
      final midMovie = existingMovies[mid];
      
      final preferred = await _showComparisonDialog(
        context: context,
        newMovie: newMovie,
        existingMovie: midMovie,
        category: category,
      );
      
      if (preferred == newMovie) {
        // New movie is preferred over mid movie
        right = mid - 1;
      } else {
        // Existing movie is preferred over new movie
        left = mid + 1;
      }
    }
    
    return left; // Position where the new movie should be inserted
  }

  // Show the comparison dialog and return the preferred movie
  static Future<RatedMovie> _showComparisonDialog({
    required BuildContext context,
    required RatedMovie newMovie,
    required RatedMovie existingMovie,
    required String category,
  }) async {
    return await showDialog<RatedMovie>(
      context: context,
      barrierDismissible: false,
      builder: (context) => MovieComparisonDialog(
        newMovie: newMovie,
        existingMovie: existingMovie,
        category: category,
        onNewMoviePreferred: () => Navigator.of(context).pop(newMovie),
        onExistingMoviePreferred: () => Navigator.of(context).pop(existingMovie),
      ),
    ) ?? newMovie; // Default to new movie if dialog is dismissed somehow
  }

  // Insert movie at specific position in the specified category
  static void insertMovieAtPosition({
    required UserRatingState ratingState,
    required RatedMovie movie,
    required int position,
    required String category,
  }) {
    switch (category.toLowerCase()) {
      case 'good':
        ratingState.insertGoodMovieAtPosition(movie, position);
        break;
      case 'okay':
        ratingState.insertOkayMovieAtPosition(movie, position);
        break;
      case 'bad':
        ratingState.insertBadMovieAtPosition(movie, position);
        break;
    }
  }
}
