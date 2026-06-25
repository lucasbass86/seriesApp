import 'dart:convert';

MultiSeach multiSeachFromJson(String str) => MultiSeach.fromJson(json.decode(str));

class MultiSeach {
  int page;
  List<MultiSeachResult> results;
  int totalPages;
  int totalResults;

  MultiSeach({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory MultiSeach.fromJson(Map<String, dynamic> json) => MultiSeach(
    page: json["page"],
    results: List<MultiSeachResult>.from(json["results"].map((x) => MultiSeachResult.fromJson(x))),
    totalPages: json["total_pages"],
    totalResults: json["total_results"],
  );
}

class MultiSeachResult {
  bool adult;
  String? backdropPath;
  int id;
  String? name;
  String? originalName;
  String? overview;
  String? posterPath;
  String? mediaType;
  List<int>? genreIds;
  double popularity;
  DateTime? firstAirDate;
  double? voteAverage;
  int? voteCount;
  int? gender;
  String? profilePath;
  String? title;
  String? originalTitle;
  DateTime? releaseDate;

  MultiSeachResult({
    required this.adult,
    this.backdropPath,
    required this.id,
    this.name,
    this.originalName,
    this.overview,
    this.posterPath,
    required this.mediaType,
    this.genreIds,
    required this.popularity,
    this.firstAirDate,
    this.voteAverage,
    this.voteCount,
    this.gender,
    this.profilePath,
    this.title,
    this.originalTitle,
    this.releaseDate,
  });

  factory MultiSeachResult.fromJson(Map<String, dynamic> json) => MultiSeachResult(
    adult: json["adult"],
    backdropPath: json["backdrop_path"],
    id: json["id"],
    name: json["name"],
    originalName: json["original_name"],
    overview: json["overview"],
    posterPath: json["poster_path"],
    mediaType: json["media_type"],
    genreIds: json["genre_ids"] == null ? [] : List<int>.from(json["genre_ids"]!.map((x) => x)),
    popularity: json["popularity"]?.toDouble(),
    firstAirDate:
        json["first_air_date"] == null
            ? null
            : json["first_air_date"] != ''
            ? DateTime.parse(json["first_air_date"])
            : null,
    voteAverage: json["vote_average"]?.toDouble(),
    voteCount: json["vote_count"],
    gender: json["gender"],
    profilePath: json["profile_path"],
    title: json["title"],
    originalTitle: json["original_title"],
    releaseDate:
        json["release_date"] == null
            ? null
            : json["release_date"] != ''
            ? DateTime.parse(json["release_date"])
            : null,
  );
}
