import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:netflix_clone/Common/utils.dart';
import 'package:netflix_clone/Model/movie_details.dart';
import 'package:netflix_clone/Model/movie_recommendation.dart';
import 'package:netflix_clone/Providers/user_rating_state.dart';
import 'package:netflix_clone/Services/api_services.dart';
import 'package:netflix_clone/Screen/rating_page.dart';

class MovieDetailedScreen extends StatefulWidget {
  final String posterPath;
  final String backdropPath;
  final String title;
  final String overview;
  final String releaseDate;
  final String originalLanguage;
  final int movieId;
  const MovieDetailedScreen({
    super.key,
    required this.movieId,
    required this.posterPath,
    required this.backdropPath,
    required this.title,
    required this.overview,
    required this.releaseDate,
    required this.originalLanguage,
  });

  @override
  State<MovieDetailedScreen> createState() => _MovieDetailedScreenState();
}

class _MovieDetailedScreenState extends State<MovieDetailedScreen> {
  final ApiServices apiServices = ApiServices();
  late Future<MovieDetail?> movieDetail;
  late Future<MovieRecommedations?> movieRecommendation;
  @override
  void initState() {
    fetchMovieData();
    super.initState();
  }

  fetchMovieData() async {
    movieDetail = apiServices.movieDetail(widget.movieId);
    movieRecommendation = apiServices.movieRecommendation(widget.movieId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // String formatRuntime(int runtime) {
    //   int hours = runtime ~/ 60; // Integer division
    //   int minutes = runtime % 60;

    //   return '${hours}h ${minutes}m';
    // }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child:
        // FutureBuilder(
        //   future: movieDetail,
        //   builder: (context, snapshot) {
        //     if (snapshot.hasData) {
        //       final movie = snapshot.data!;
        //       String generesText = movie.genres
        //           .map((genere) => genere.name)
        //           .join(", ");
        //       return
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: size.height * 0.4,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      // some time it don't display the image due to different reason like,internet issiue, permission etc
                      image: CachedNetworkImageProvider(
                        "$imageUrl${widget.backdropPath}",
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 15,
                  top: 50,
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: GestureDetector(
                          onTap: Navigator.of(context).pop,
                          child: Icon(Icons.close, color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: Icon(Icons.cast, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 100,
                  bottom: 100,
                  right: 100,
                  left: 100,
                  child: Icon(
                    Icons.play_circle_outline,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: Text(
                          widget.title,
                          // movie.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 1,
                        child: Image.asset(
                          "assets/netflix.png",
                          height: 80,
                          width: 50,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        widget.releaseDate,
                        // movie.releaseDate.year.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 10),
                      // Text(
                      //   formatRuntime(movie.runtime),
                      //   style: TextStyle(
                      //     fontWeight: FontWeight.bold,
                      //     fontSize: 16,
                      //     color: Colors.white,
                      //   ),
                      // ),
                      Text(
                        widget.originalLanguage,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),  
                      Text(
                        "HD",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white60,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_arrow, size: 30, color: Colors.black),
                    Text(
                      "Play",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.download, size: 30, color: Colors.white),
                    Text(
                      "Download",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),

            Text(
              widget.overview,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Icon(Icons.add, size: 45, color: Colors.white),
                    Text(
                      "My List",
                      style: TextStyle(color: Colors.white, height: 0.5),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RatingPage(
                          movie: RatedMovie(
                            id: widget.movieId,
                            title: widget.title,
                            posterPath: widget.posterPath,
                            releaseDate: widget.releaseDate,
                            overview: widget.overview,
                          ),
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Icon(Icons.thumb_up, size: 40, color: Colors.white),
                      Text(
                        "Rate",
                        style: TextStyle(color: Colors.white, height: 0.5),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Icon(Icons.share, size: 40, color: Colors.white),
                    Text(
                      "Share",
                      style: TextStyle(color: Colors.white, height: 0.5),
                    ),
                  ],
                ),
              ],
            ),
            // SizedBox(height: 20),
            // FutureBuilder(
            //   future: movieRecommendation,
            //   builder: (context, snapshot) {
            //     if (snapshot.hasData) {
            //       final movie = snapshot.data;
            //       return movie!.results.isEmpty
            //           ? SizedBox()
            //           : Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Text(
            //                 "More Like This",
            //                 style: TextStyle(
            //                   color: Colors.white,
            //                   fontWeight: FontWeight.bold,
            //                   fontSize: 18,
            //                 ),
            //               ),
            //               SizedBox(height: 20),
            //               SizedBox(
            //                 height: 200,
            //                 child: ListView.builder(
            //                   scrollDirection: Axis.horizontal,
            //                   shrinkWrap: true,
            //                   padding: EdgeInsets.zero,
            //                   itemCount: movie.results.length,
            //                   itemBuilder: (context, index) {
            //                     return Padding(
            //                       padding: const EdgeInsets.only(right: 5),
            //                       child: CachedNetworkImage(
            //                         imageUrl:
            //                             "$imageUrl${movie.results[index].posterPath}",
            //                         height: 200,
            //                         width: 150,
            //                         fit: BoxFit.cover,
            //                       ),
            //                     );
            //                   },
            //                 ),
            //               ),
            //             ],
            //           );
            //     }
            //     return Text("Something Went Wrong");
            //   },
            // ),
          ],
        ),
      ),
    );
  }

}
