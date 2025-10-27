import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../Providers/user_rating_state.dart';

class ComparisonScreen extends StatefulWidget {
  final RatedMovie newMovie;
  final RatedMovie firstMovie;
  final String category;
  final Function(RatedMovie) onComparisonComplete;

  const ComparisonScreen({
    super.key,
    required this.newMovie,
    required this.firstMovie,
    required this.category,
    required this.onComparisonComplete,
  });

  @override
  State<ComparisonScreen> createState() => _ComparisonScreenState();
}

class _ComparisonScreenState extends State<ComparisonScreen> {
  late RatedMovie newMovie;
  late RatedMovie existingMovie;
  
  @override
  void initState() {
    super.initState();
    newMovie = widget.newMovie;
    existingMovie = widget.firstMovie;
    
    // Listen for updates to the existing movie
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupListener();
    });
  }
  
  void _setupListener() {
    // Create a way to update the screen when needed
    // We'll use a static callback pattern
  }
  
  void _handleSelection(RatedMovie preferred) {
    widget.onComparisonComplete(preferred);
    Navigator.pop(context, preferred);
  }
  
  void updateExistingMovie(RatedMovie newExistingMovie) {
    setState(() {
      existingMovie = newExistingMovie;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: null,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Which movie do you prefer?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Movies comparison
            Row(
              children: [
                // New Movie (Left)
                Expanded(
                  child: GestureDetector(
                    onTap: () => _handleSelection(newMovie),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.withOpacity(0.5)),
                      ),
                      child: Column(
                        children: [
                          // Movie poster
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: newMovie.fullPosterUrl,
                              width: 120,
                              height: 180,
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
                          const SizedBox(height: 12),
                          
                          // Movie title
                          Text(
                            newMovie.title,
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
                            newMovie.year,
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // VS divider
                SizedBox(width: 12),

                // Existing Movie (Right)
                Expanded(
                  child: GestureDetector(
                    onTap: () => _handleSelection(existingMovie),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.withOpacity(0.5)),
                      ),
                      child: Column(
                        children: [
                          // Movie poster
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: existingMovie.fullPosterUrl,
                              width: 120,
                              height: 180,
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
                          const SizedBox(height: 12),
                          
                          // Movie title
                          Text(
                            existingMovie.title,
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
                            existingMovie.year,
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

