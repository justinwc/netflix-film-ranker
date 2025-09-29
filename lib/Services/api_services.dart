// ignore_for_file: avoid_print

import 'package:netflix_clone/Model/movie_details.dart';
import 'package:netflix_clone/Model/movie_model.dart';
import 'package:netflix_clone/Model/movie_recommendation.dart';
import 'package:netflix_clone/Model/poplar_tv_series.dart';
import 'package:netflix_clone/Model/search_movie.dart';
import 'package:netflix_clone/Model/tmdb_trending.dart';
import 'package:netflix_clone/Model/top_rated_movies.dart';
import 'package:netflix_clone/Model/trending_movei.dart';
import 'package:netflix_clone/Model/upcoming_movie_model.dart';
import 'package:netflix_clone/common/utils.dart';
import 'dart:io'; // For handling SocketException
import 'package:http/http.dart' as http;

var key = "?api_key=$apiKey";

class ApiServices {
  // now playing movies
  Future<Movie?> fetchMovies() async {
    try {
      const endPoint = "movie/now_playing";
      final apiUrl = "$baseUrl$endPoint$key";
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        return movieFromJson(response.body);
      } else {
        throw Exception("Failed to load movies");
      }
    } catch (e) {
      print("Error fetching movies :$e");
      return null;
    }
  }
   // Upcoming movies
  Future<UpcomingMovies?> upcomingMovies() async {
    try {
      const endPoint = "movie/upcoming";
      final apiUrl = "$baseUrl$endPoint$key";
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        return upcomingMoviesFromJson(response.body);
      } else {
        throw Exception("Failed to load movies");
      }
    } catch (e) {
      print("Error fetching movies :$e");
      return null;
    }
  }
   // Trending movies
  Future<TrendingMovies?> trendingMovies() async {
    try {
      const endPoint = "trending/movie/day";
      final apiUrl = "$baseUrl$endPoint$key";
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        return trendingMoviesFromJson(response.body);
      } else {
        throw Exception("Failed to load movies");
      }
    } catch (e) {
      print("Error fetching movies :$e");
      return null;
    }
  }
     //  TopRated movies
  Future<TopRatedMovies?> topRatedMovies() async {
    try {
      const endPoint = "movie/top_rated";
      final apiUrl = "$baseUrl$endPoint$key";
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        return topRatedMoviesFromJson(response.body);
      } else {
        throw Exception("Failed to load movies");
      }
    } catch (e) {
      print("Error fetching movies :$e");
      return null;
    }
  }
    // popular TV Series
  Future<PopularTVseries?> popularTvSeries() async {
    try {
      const endPoint = "tv/popular";
      final apiUrl = "$baseUrl$endPoint$key";
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        return popularTVseriesFromJson(response.body);
      } else {
        throw Exception("Failed to load movies");
      }
    } catch (e) {
      print("Error fetching movies :$e");
      return null;
    }
  }
   // Movie detail
   // i have not used detail api due to some issues on this api
  Future<MovieDetail?> movieDetail(int movieId) async {
    try {
      final endPoint = "movie/$movieId";
      final apiUrl = "$baseUrl$endPoint$key";
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        return movieDetailFromJson(response.body);
      } else {
        print("Failed to load movies: ${response.statusCode}");
        return null;
      }
    } on SocketException catch (e) {
      print("No internet connection: $e");
      return null;
    } on HttpException catch (e) {
      print("Bad response: $e");
      return null;
    } on FormatException catch (e) {
      print("Bad JSON format: $e");
      return null;
    } catch (e) {
      print("Unexpected error: $e");
      return null;
    }
  }

   // Movie Recommedations
  Future<MovieRecommedations?> movieRecommendation(int movieId) async {
    try {
      final endPoint = "movie/$movieId/recommendations";
      final apiUrl = "$baseUrl$endPoint$key";
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        return movieRecommedationsFromJson(response.body);
      } else {
        throw Exception("Failed to load movies");
      }
    } catch (e) {
      print("Error fetching movies :$e");
      return null;
    }
  }
  // searchMovie
  Future<SearchMovie?> searchMovie(String query) async {
    // some time, only api key is not workin on search api, insted of this user a token key 
    try {
      final endPoint = "search/movie?query=$query";
      final apiUrl = "$baseUrl$endPoint";
      final response = await http.get(Uri.parse(apiUrl),headers: { 
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxZjAzOGQ5Njg3ODEyMjQ0Y2I5MTkxNjhkZTM4NjhkMCIsIm5iZiI6MTc0MjI4NDA0NS41MTgwMDAxLCJzdWIiOiI2N2Q5MjUwZDBhZjYyMjU4YTkzNjUzMTEiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.rOoguCmVKmySyC_bIiq4ANlr6v2tPZPhf4IHy4FMVlM"
      });
      if (response.statusCode == 200) {
        return searchMovieFromJson(response.body);
      } else {
        throw Exception("Failed to load movies");
      }
    } catch (e) {
      print("Error fetching movies :$e");
      return null;
    }
  }
    // TMDb Trending API
  Future<TmdbTrending?> tmdbTrending() async {
    try {
      final endPoint = "trending/all/day";
      final apiUrl = "$baseUrl$endPoint$key";
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        return tmdbTrendingFromJson(response.body);
      } else {
        throw Exception("Failed to load movies");
      }
    } catch (e) {
      print("Error fetching movies :$e");
      return null;
    }
  }
}
