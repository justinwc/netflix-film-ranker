import 'package:flutter/material.dart';
import '../Providers/user_rating_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:netflix_clone/Common/utils.dart';
import 'comparison_screen.dart';

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
                          selectedRating == "Bad",
                          () {
                            setState(() => selectedRating = "Bad");
                            _submitRating();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingButton(String label, IconData icon, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: Colors.white54,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white70,
              size: 24,
            ),
            SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitRating() {
    final rating = selectedRating!;
    
    // Navigate to comparison screen with the rating
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ComparisonScreen(
            newMovie: widget.movie,
            rating: rating,
          ),
        ),
      );
    }
  }
}
