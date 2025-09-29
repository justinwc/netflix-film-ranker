import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../Providers/user_rating_state.dart';
import '../Model/simple_movie.dart';

class MyNetflix extends StatefulWidget {
  const MyNetflix({super.key});

  @override
  State<MyNetflix> createState() => _MyNetflixState();
}

class _MyNetflixState extends State<MyNetflix> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'My Netflix',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
      body: Consumer<UserRatingState>(
        builder: (context, ratingState, child) {
          return Column(
            children: [
              const SizedBox(height: 10),
              
              // User profile section
              Center(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/user-icon.jpg',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const Text(
                      'Justin',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${ratingState.totalRatedMovies} movies rated',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              // Rated movies list
              Expanded(
                child: ratingState.totalRatedMovies == 0
                    ? _buildEmptyState()
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Good Movies Section
                            if (ratingState.goodMovies.isNotEmpty) ...[
                              _buildMovieSection('Good Movies', ratingState.goodMovies, Colors.green),
                              const SizedBox(height: 20),
                            ],
                            
                            // Okay Movies Section
                            if (ratingState.okayMovies.isNotEmpty) ...[
                              _buildMovieSection('Okay Movies', ratingState.okayMovies, Colors.orange),
                              const SizedBox(height: 20),
                            ],
                            
                            // Bad Movies Section
                            if (ratingState.badMovies.isNotEmpty) ...[
                              _buildMovieSection('Bad Movies', ratingState.badMovies, Colors.red),
                              const SizedBox(height: 20),
                            ],
                          ],
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.star_border,
              size: 80,
              color: Colors.white38,
            ),
            const SizedBox(height: 20),
            const Text(
              'No movies rated yet',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Rate some movies to see them here',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieSection(String title, List<SimpleMovie> movies, Color accentColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(
                _getRatingIcon(title),
                color: accentColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${movies.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        
        // Movie list
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return _buildMovieCard(movie, accentColor);
          },
        ),
      ],
    );
  }

  Widget _buildMovieCard(SimpleMovie movie, Color accentColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          // Movie poster
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: movie.fullPosterUrl,
              width: 60,
              height: 90,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: 60,
                height: 90,
                color: Colors.grey[800],
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                width: 60,
                height: 90,
                color: Colors.grey[800],
                child: const Icon(
                  Icons.movie,
                  color: Colors.white54,
                  size: 30,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Movie details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  movie.year,
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    if (movie.voteAverage != null) ...[
                      Icon(
                        Icons.star,
                        color: accentColor,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${movie.voteAverage!.toStringAsFixed(1)}',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getRatingLabel(accentColor),
                        style: TextStyle(
                          color: accentColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  IconData _getRatingIcon(String title) {
    switch (title) {
      case 'Good Movies':
        return Icons.thumb_up;
      case 'Okay Movies':
        return Icons.thumbs_up_down;
      case 'Bad Movies':
        return Icons.thumb_down;
      default:
        return Icons.star;
    }
  }

  String _getRatingLabel(Color accentColor) {
    if (accentColor == Colors.green) return 'Good';
    if (accentColor == Colors.orange) return 'Okay';
    if (accentColor == Colors.red) return 'Bad';
    return 'Unknown';
  }
}