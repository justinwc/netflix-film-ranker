import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../Providers/user_rating_state.dart';

class MovieComparisonDialog extends StatelessWidget {
  final RatedMovie newMovie;
  final RatedMovie existingMovie;
  final String category;
  final VoidCallback onNewMoviePreferred;
  final VoidCallback onExistingMoviePreferred;

  const MovieComparisonDialog({
    super.key,
    required this.newMovie,
    required this.existingMovie,
    required this.category,
    required this.onNewMoviePreferred,
    required this.onExistingMoviePreferred,
  });

  @override
  Widget build(BuildContext context) {
    
    return Dialog(
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Column(
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
                const SizedBox(height: 8),
              ],
            ),
            const SizedBox(height: 24),

            // Movies comparison
            Row(
              children: [
                // New Movie (Left)
                Expanded(
                  child: GestureDetector(
                    onTap: onNewMoviePreferred,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.withOpacity(0.5)),
                      ),
                      child: Column(
                        children: [
                          // Movie poster
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: newMovie.fullPosterUrl,
                              width: 80,
                              height: 120,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                width: 80,
                                height: 120,
                                color: Colors.grey[800],
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                width: 80,
                                height: 120,
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      // Container(
                      //   width: 2,
                      //   height: 60,
                      //   color: Colors.white24,
                      // ),
                      //const SizedBox(height: 8),
                      const Text(
                        'VS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      //const SizedBox(height: 8),
                      // Container(
                      //   width: 2,
                      //   height: 60,
                      //   color: Colors.white24,
                      // ),
                    ],
                  ),
                ),

                // Existing Movie (Right)
                Expanded(
                  child: GestureDetector(
                    onTap: onExistingMoviePreferred,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.withOpacity(0.5)),
                      ),
                      child: Column(
                        children: [
                          // Movie poster
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: existingMovie.fullPosterUrl,
                              width: 80,
                              height: 120,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                width: 80,
                                height: 120,
                                color: Colors.grey[800],
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                width: 80,
                                height: 120,
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
