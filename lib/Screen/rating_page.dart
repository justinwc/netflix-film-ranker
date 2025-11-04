import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/user_rating_state.dart';
import '../Services/beli_ranking_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:netflix_clone/Common/utils.dart';

class RatingPage extends StatefulWidget {
  final RatedMovie movie;
  
  const RatingPage({
    super.key,
    required this.movie,
  });

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  String? selectedRating;

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
            
            // Rating content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Rate this film",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 25),
                    
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

                    SizedBox(height: 30),
                    // Rating buttons
                    Column(
                      children: [
                        // Good button
                        _buildRatingButton(
                          "Good",
                          Icons.thumb_up,
                          Colors.green,
                          selectedRating == "Good",
                          () {
                            setState(() => selectedRating = "Good");
                            _submitRating();
                          },
                        ),
                        SizedBox(height: 15),
                        
                        // Okay button
                        _buildRatingButton(
                          "Okay",
                          Icons.thumbs_up_down,
                          Colors.orange,
                          selectedRating == "Okay",
                          () {
                            setState(() => selectedRating = "Okay");
                            _submitRating();
                          },
                        ),
                        SizedBox(height: 15),
                        
                        // Bad button
                        _buildRatingButton(
                          "Bad",
                          Icons.thumb_down,
                          Colors.red,
                          selectedRating == "Bad",
                          () {
                            setState(() => selectedRating = "Bad");
                            _submitRating();
                          },
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 40),
                    
                    // Submit rating button
                    // if (selectedRating != null)
                    //   ElevatedButton(
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: Colors.red,
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(20),
                    //       ),
                    //       padding: EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                    //     ),
                    //     onPressed: _submitRating,
                    //     child: Text(
                    //       "Submit Rating",
                    //       style: TextStyle(
                    //         color: Colors.white,
                    //         fontSize: 18,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //   ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingButton(String label, IconData icon, Color color, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : Colors.transparent,
          border: Border.all(
            color: isSelected ? color : Colors.white54,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? color : Colors.white70,
              size: 24,
            ),
            SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? color : Colors.white70,
                fontSize: 18,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitRating() async {
    // Get the rating state provider
    final ratingState = Provider.of<UserRatingState>(context, listen: false);
    final rating = selectedRating!; // Capture before async

    // Use Beli ranking system for all rating categories
    try {
      List<RatedMovie> existingMovies;

      switch (rating.toLowerCase()) {
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

      final position = await BeliRankingService.findMoviePosition(
        context: context,
        newMovie: widget.movie,
        existingMovies: existingMovies,
        category: rating,
      );

      BeliRankingService.insertMovieAtPosition(
        ratingState: ratingState,
        movie: widget.movie,
        position: position,
        category: rating,
      );

    } catch (e) {
      // Fallback to regular rating if Beli system fails
      ratingState.addRating(widget.movie, rating);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Rating saved: $rating"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}
