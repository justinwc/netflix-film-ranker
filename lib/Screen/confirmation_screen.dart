import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:netflix_clone/Common/utils.dart';
import 'package:netflix_clone/Providers/user_rating_state.dart';
import 'package:netflix_clone/Screen/app_navbar_screen.dart';

class ConfirmationScreen extends StatefulWidget {
  final RatedMovie movie;
  final String rating;
  final int position;

  const ConfirmationScreen({
    super.key,
    required this.movie,
    required this.rating,
    required this.position,
  });

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  int _calculateUnifiedRank(UserRatingState ratingState) {
    int baseRank = 0;
    
    // Calculate base rank based on category
    switch (widget.rating.toLowerCase()) {
      case 'good':
        // Good movies start at rank 1
        baseRank = 0;
        break;
      case 'okay':
        // Okay movies come after all Good movies
        baseRank = ratingState.goodMovies.length;
        break;
      case 'bad':
        // Bad movies come after all Good and Okay movies
        baseRank = ratingState.goodMovies.length + ratingState.okayMovies.length;
        break;
    }
    
    // Add the position within the category (1-indexed)
    return baseRank + widget.position + 1;
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

            Container(
              height: 280,
              width: 188,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.withOpacity(0.5),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(
                    "$imageUrl${widget.movie.posterPath}",
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),
            // Movie title
            Text(
              widget.movie.title,
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
              widget.movie.year,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 12,
              ),
            ),
            
            const SizedBox(height: 20),
            // Unified rank display
            Consumer<UserRatingState>(
              builder: (context, ratingState, child) {
                final unifiedRank = _calculateUnifiedRank(ratingState);
                return Text(
                  'Ranked #$unifiedRank',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                );
              },
            ),
            
            const SizedBox(height: 40),
            // Submit button
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return GestureDetector(
      onTap: () {
        // Insert movie at position directly in UserRatingState
        final ratingState = Provider.of<UserRatingState>(context, listen: false);
        
        switch (widget.rating.toLowerCase()) {
          case 'good':
            ratingState.insertGoodMovieAtPosition(widget.movie, widget.position);
            break;
          case 'okay':
            ratingState.insertOkayMovieAtPosition(widget.movie, widget.position);
            break;
          case 'bad':
            ratingState.insertBadMovieAtPosition(widget.movie, widget.position);
            break;
        }
        
        // Navigate to home screen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => AppNavbarScreen()),
          (route) => false, // Remove all previous routes
        );
      },
      child: Container(
        width: 200,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: Colors.white54,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check,
              color: Colors.white70,
              size: 24,
            ),
            SizedBox(width: 10),
            Text(
              'Done',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}