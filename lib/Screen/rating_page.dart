import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/user_rating_state.dart';
import '../Services/beli_ranking_service.dart';

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
      backgroundColor: Colors.black,
      body: Column(
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
          
          // Rating content - takes up the whole screen
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Rate ${widget.movie.title}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40),
                  
                  // Rating buttons
                  Column(
                    children: [
                      // Good button
                      _buildRatingButton(
                        "Good",
                        Icons.thumb_up,
                        Colors.green,
                        selectedRating == "Good",
                        () => setState(() => selectedRating = "Good"),
                      ),
                      SizedBox(height: 20),
                      
                      // Okay button
                      _buildRatingButton(
                        "Okay",
                        Icons.thumbs_up_down,
                        Colors.orange,
                        selectedRating == "Okay",
                        () => setState(() => selectedRating = "Okay"),
                      ),
                      SizedBox(height: 20),
                      
                      // Bad button
                      _buildRatingButton(
                        "Bad",
                        Icons.thumb_down,
                        Colors.red,
                        selectedRating == "Bad",
                        () => setState(() => selectedRating = "Bad"),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  
                  Text(
                    selectedRating == null 
                      ? "Select how you feel about this movie"
                      : "You rated this as ${selectedRating!.toLowerCase()}",
                    style: TextStyle(
                      color: selectedRating == null ? Colors.white70 : Colors.white,
                      fontSize: 18,
                      fontWeight: selectedRating == null ? FontWeight.normal : FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  SizedBox(height: 40),
                  
                  // Submit rating button
                  if (selectedRating != null)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                      ),
                      onPressed: () async {
                        // Get the rating state provider
                        final ratingState = Provider.of<UserRatingState>(context, listen: false);
                        
                        // Use Beli ranking system for all rating categories
                        try {
                          List<RatedMovie> existingMovies;
                          Color successColor;
                          
                          switch (selectedRating!.toLowerCase()) {
                            case 'good':
                              existingMovies = ratingState.goodMovies;
                              successColor = Colors.green;
                              break;
                            case 'okay':
                              existingMovies = ratingState.okayMovies;
                              successColor = Colors.orange;
                              break;
                            case 'bad':
                              existingMovies = ratingState.badMovies;
                              successColor = Colors.red;
                              break;
                            default:
                              existingMovies = [];
                              successColor = Colors.red;
                          }
                          
                          final position = await BeliRankingService.findMoviePosition(
                            context: context,
                            newMovie: widget.movie,
                            existingMovies: existingMovies,
                            category: selectedRating!,
                          );
                          
                          BeliRankingService.insertMovieAtPosition(
                            ratingState: ratingState,
                            movie: widget.movie,
                            position: position,
                            category: selectedRating!,
                          );
                          
                          // Show confirmation
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Movie ranked at position ${position + 1} in ${selectedRating} movies!"),
                              backgroundColor: successColor,
                            ),
                          );
                        } catch (e) {
                          // Fallback to regular rating if Beli system fails
                          ratingState.addRating(widget.movie, selectedRating!);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Rating saved: ${selectedRating}"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                        
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Submit Rating",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
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
          borderRadius: BorderRadius.circular(25),
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
}
