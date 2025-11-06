import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:netflix_clone/Screen/confirmation_screen.dart';
import '../Providers/user_rating_state.dart';

class ComparisonScreen extends StatefulWidget {
  final RatedMovie newMovie;
  final String rating;

  const ComparisonScreen({
    super.key,
    required this.newMovie,
    required this.rating,
  });

  @override
  State<ComparisonScreen> createState() => _ComparisonScreenState();
}

class _ComparisonScreenState extends State<ComparisonScreen> {
  late RatedMovie newMovie;
  RatedMovie? existingMovie;
  late List<RatedMovie> existingMovies;
  int? position;
  bool _isFindingPosition = true;
  
  // Binary search state
  int _left = 0;
  int _right = 0;
  
  @override
  void initState() {
    super.initState();
    newMovie = widget.newMovie;
    _initializeRanking();
  }

  void _initializeRanking() {
    final ratingState = Provider.of<UserRatingState>(context, listen: false);
    
    // Get existing movies for this rating category
    switch (widget.rating.toLowerCase()) {
      case 'good':
        existingMovies = ratingState.goodMovies;
        break;
      case 'okay':
        existingMovies = ratingState.okayMovies;
        break;
      case 'bad':
        existingMovies = ratingState.badMovies;
        break;
      default:
        existingMovies = [];
    }

    if (existingMovies.isEmpty) {
      // No existing movies, position is 0
      position = 0;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigateToConfirmation();
      });
      return;
    }

    if (existingMovies.length == 1) {
      // Compare with the single existing movie
      setState(() {
        existingMovie = existingMovies[0];
        _isFindingPosition = true;
        _left = 0;
        _right = 0;
      });
      return;
    }

    // Start binary search
    _startBinarySearch();
  }

  void _startBinarySearch() {
    _left = 0;
    _right = existingMovies.length - 1;
    
    setState(() {
      // Start with the middle movie
      int mid = (_left + _right) ~/ 2;
      existingMovie = existingMovies[mid];
      _isFindingPosition = true;
    });
  }

  void _handleSelection(RatedMovie preferred) {
    if (!_isFindingPosition || existingMovie == null) return;
    
    final newMoviePreferred = preferred == newMovie;
    
    // Handle single movie case
    if (existingMovies.length == 1) {
      position = newMoviePreferred ? 0 : 1;
      _navigateToConfirmation();
      return;
    }
    
    if (newMoviePreferred) {
      // New movie is preferred over mid movie, search left half
      _right = existingMovies.indexOf(existingMovie!) - 1;
    } else {
      // Existing movie is preferred, search right half
      _left = existingMovies.indexOf(existingMovie!) + 1;
    }
    
    // Check if binary search is complete
    if (_left <= _right) {
      // Continue binary search
      setState(() {
        int mid = (_left + _right) ~/ 2;
        existingMovie = existingMovies[mid];
      });
    } else {
      // Binary search complete, position is _left
      position = _left;
      _navigateToConfirmation();
    }
  }

  void _navigateToConfirmation() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmationScreen(
          movie: newMovie,
          rating: widget.rating,
          position: position ?? 0,
        ),
      ),
    );
  }

  Widget _buildMovieWidget(RatedMovie movie, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          // Movie poster with grey border
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.withOpacity(0.5),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: movie.fullPosterUrl,
                width: 170,
                height: 240,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 120,
                  height: 180,
                  color: Colors.grey[800],
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 120,
                  height: 180,
                  color: Colors.grey[800],
                  child: const Icon(
                    Icons.movie,
                    color: Colors.white54,
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Movie title
          Text(
            movie.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          // Year
          Text(
            movie.year,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF7A0000), // deep red top
              Colors.black,      // black bottom
            ],
            stops: [0.1, 0.6],
          ),
        ),
        child: Column(
          children: [
            // Close button
            Padding(
              padding: const EdgeInsets.only(top: 50, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            Text(
              'Which movie do you prefer?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 100),
            // Comparison content
            Expanded(
              child: existingMovie != null
                  ? Padding(
                        padding: const EdgeInsets.all(24),
                        child: Row(
                          children: [
                            // New Movie (Left)
                            Expanded(
                              child: _buildMovieWidget(
                                newMovie,
                                () => _handleSelection(newMovie),
                              ),
                            ),

                            // VS divider
                            SizedBox(width: 12),

                            // Existing Movie (Right)
                            Expanded(
                              child: _buildMovieWidget(
                                existingMovie!,
                                () => _handleSelection(existingMovie!),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

