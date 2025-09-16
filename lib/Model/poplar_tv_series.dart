// To parse this JSON data, do
//
//     final popularTVseries = popularTVseriesFromJson(jsonString);

import 'dart:convert';

PopularTVseries popularTVseriesFromJson(String str) =>
    PopularTVseries.fromJson(json.decode(str));

String popularTVseriesToJson(PopularTVseries data) =>
    json.encode(data.toJson());

class PopularTVseries {
  int page;
  List<Result> results;
  int totalPages;
  int totalResults;

  PopularTVseries({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory PopularTVseries.fromJson(Map<String, dynamic> json) =>
      PopularTVseries(
        page: json["page"],
        results: List<Result>.from(
          json["results"].map((x) => Result.fromJson(x)),
        ),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );

  Map<String, dynamic> toJson() => {
    "page": page,
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
    "total_pages": totalPages,
    "total_results": totalResults,
  };
}

class Result {
  bool adult;
  String? backdropPath;
  List<int> genreIds;
  int id;
  List<String> originCountry;
  String originalLanguage;
  String originalName;
  String overview;
  double popularity;
  String posterPath;
  // change the name fo firstAirDate to releaseDate becuase in our all reminag api model it used releaseDate nor firstAirDate
  DateTime releaseDate;
  // same fro title as well, change the name to title
  String title;
  double voteAverage;
  int voteCount;

  Result({
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originCountry,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.voteAverage,
    required this.voteCount,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    adult: json["adult"],
    backdropPath: json["backdrop_path"],
    genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
    id: json["id"],
    originCountry: List<String>.from(json["origin_country"].map((x) => x)),
    originalLanguage: json["original_language"],
    originalName: json["original_name"],
    overview: json["overview"],
    popularity: json["popularity"]?.toDouble(),
    posterPath: json["poster_path"],
    releaseDate: DateTime.parse(json["first_air_date"]),
    title: json["name"],
    voteAverage: json["vote_average"]?.toDouble(),
    voteCount: json["vote_count"],
  );

  Map<String, dynamic> toJson() => {
    "adult": adult,
    "backdrop_path": backdropPath,
    "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
    "id": id,
    "origin_country": List<dynamic>.from(originCountry.map((x) => x)),
    "original_language": originalLanguage,
    "original_name": originalName,
    "overview": overview,
    "popularity": popularity,
    "poster_path": posterPath,
    "first_air_date":
        "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
    "name": title,
    "vote_average": voteAverage,
    "vote_count": voteCount,
  };
}
