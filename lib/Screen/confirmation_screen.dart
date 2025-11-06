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
  late final int _unifiedRank;
  late final double _numericalRating;

  @override
  void initState() {
    super.initState();
    // Calculate values once before the movie is added to avoid recalculation
    final ratingState = Provider.of<UserRatingState>(context, listen: false);
    _unifiedRank = ratingState.calculateUnifiedRank(
      widget.rating,
      widget.position,
    );
    _numericalRating = ratingState.calculateNumericalRating(
      widget.rating,
      widget.position,
      false,
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

            const SizedBox(height: 40),

            // Movie poster with shadow effect
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 5,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Container(
                height: 300,
                width: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                      "$imageUrl${widget.movie.posterPath}",
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 42),
            
            Center(
              child: Container(
                width: 320,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    // Rating with star icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 32,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _numericalRating.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Divider
                    Container(
                      height: 1,
                      width: 60,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Rank
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '#$_unifiedRank',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Overall',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            //const Spacer(),
            
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