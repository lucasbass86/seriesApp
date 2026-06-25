import 'dart:convert';

import 'package:seriesapp/models/_models.dart';

MovieModel movieModelFromJson(String str) => MovieModel.fromJson(json.decode(str));

class MovieModel {
  bool adult;
  String backdropPath;
  BelongsToCollection? belongsToCollection;
  int budget;
  List<TvGenre> genres;
  String homepage;
  int id;
  String imdbId;
  List<String> originCountry;
  String originalLanguage;
  String originalTitle;
  String overview;
  double popularity;
  String posterPath;
  List<ProductionCompany> productionCompanies;
  List<ProductionCountry> productionCountries;
  DateTime? releaseDate;
  int revenue;
  int runtime;
  List<SpokenLanguage> spokenLanguages;
  String status;
  String tagline;
  String title;
  bool video;
  double voteAverage;
  int voteCount;

  MovieModel({
    required this.adult,
    required this.backdropPath,
    required this.belongsToCollection,
    required this.budget,
    required this.genres,
    required this.homepage,
    required this.id,
    required this.imdbId,
    required this.originCountry,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.productionCompanies,
    required this.productionCountries,
    required this.releaseDate,
    required this.revenue,
    required this.runtime,
    required this.spokenLanguages,
    required this.status,
    required this.tagline,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) => MovieModel(
    adult: json["adult"],
    backdropPath: json["backdrop_path"] ?? '',
    belongsToCollection:
        json["belongs_to_collection"] != null
            ? BelongsToCollection.fromJson(json["belongs_to_collection"])
            : null,
    budget: json["budget"],
    genres:
        json["genres"] != null
            ? List<TvGenre>.from(json["genres"].map((x) => TvGenre.fromJson(x)))
            : [],
    homepage: json["homepage"],
    id: json["id"],
    imdbId: json["imdb_id"] ?? '',
    originCountry: List<String>.from(json["origin_country"].map((x) => x)),
    originalLanguage: json["original_language"],
    originalTitle: json["original_title"],
    overview: json["overview"],
    popularity: json["popularity"]?.toDouble(),
    posterPath: json["poster_path"] ?? '',
    productionCompanies: List<ProductionCompany>.from(
      json["production_companies"].map((x) => ProductionCompany.fromJson(x)),
    ),
    productionCountries: List<ProductionCountry>.from(
      json["production_countries"].map((x) => ProductionCountry.fromJson(x)),
    ),
    releaseDate:
        json.containsKey("release_date")
            ? json["release_date"].toString().isNotEmpty
                ? DateTime.parse(json["release_date"])
                : null
            : null,
    revenue: json["revenue"],
    runtime: json["runtime"],
    spokenLanguages: List<SpokenLanguage>.from(
      json["spoken_languages"].map((x) => SpokenLanguage.fromJson(x)),
    ),
    status: json["status"],
    tagline: json["tagline"],
    title: json["title"],
    video: json["video"],
    voteAverage: json["vote_average"]?.toDouble(),
    voteCount: json["vote_count"],
  );
}

class BelongsToCollection {
  int id;
  String name;
  String posterPath;
  String backdropPath;

  BelongsToCollection({
    required this.id,
    required this.name,
    required this.posterPath,
    required this.backdropPath,
  });

  factory BelongsToCollection.fromJson(Map<String, dynamic> json) => BelongsToCollection(
    id: json["id"],
    name: json["name"],
    posterPath: json["poster_path"],
    backdropPath: json["backdrop_path"] ?? '',
  );
}

class ProductionCompany {
  int id;
  String logoPath;
  String name;
  String originCountry;

  ProductionCompany({
    required this.id,
    required this.logoPath,
    required this.name,
    required this.originCountry,
  });

  factory ProductionCompany.fromJson(Map<String, dynamic> json) => ProductionCompany(
    id: json["id"],
    logoPath: json["logo_path"] ?? '',
    name: json["name"] ?? '',
    originCountry: json["origin_country"] ?? '',
  );
}

class ProductionCountry {
  String iso31661;
  String name;

  ProductionCountry({required this.iso31661, required this.name});

  factory ProductionCountry.fromJson(Map<String, dynamic> json) =>
      ProductionCountry(iso31661: json["iso_3166_1"], name: json["name"]);
}

class SpokenLanguage {
  String englishName;
  String iso6391;
  String name;

  SpokenLanguage({required this.englishName, required this.iso6391, required this.name});

  factory SpokenLanguage.fromJson(Map<String, dynamic> json) => SpokenLanguage(
    englishName: json["english_name"] ?? '',
    iso6391: json["iso_639_1"] ?? '',
    name: json["name"] ?? '',
  );
}
