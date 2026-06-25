import 'dart:convert';

import 'package:seriesapp/models/_models.dart';

TvModel tvModelFromJson(String str) => TvModel.fromJson(json.decode(str));

class TvModel {
  bool adult;
  String backdropPath;
  List<dynamic> episodeRunTime;
  DateTime firstAirDate;
  List<TvGenre> genres;
  String homepage;
  int id;
  bool inProduction;
  List<String> languages;
  DateTime? lastAirDate;
  LastEpisodeToAir lastEpisodeToAir;
  String name;
  LastEpisodeToAir? nextEpisodeToAir;
  int numberOfEpisodes;
  int numberOfSeasons;
  List<String> originCountry;
  String originalLanguage;
  String originalName;
  String overview;
  double popularity;
  String posterPath;
  List<Season> seasons;
  String status;
  String tagline;
  String type;
  double voteAverage;
  int voteCount;

  @override
  String toString() => name;

  TvModel({
    required this.adult,
    required this.backdropPath,
    required this.episodeRunTime,
    required this.firstAirDate,
    required this.genres,
    required this.homepage,
    required this.id,
    required this.inProduction,
    required this.languages,
    required this.lastAirDate,
    required this.lastEpisodeToAir,
    required this.name,
    required this.nextEpisodeToAir,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.originCountry,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.seasons,
    required this.status,
    required this.tagline,
    required this.type,
    required this.voteAverage,
    required this.voteCount,
  });

  factory TvModel.fromJson(Map<String, dynamic> json) {
    return TvModel(
      adult: json["adult"] ?? false,
      backdropPath: json["backdrop_path"] ?? "",
      episodeRunTime:
          json["episode_run_time"] != null
              ? List<dynamic>.from(json["episode_run_time"].map((x) => x))
              : [],
      firstAirDate:
          json["first_air_date"] != null && json["first_air_date"].isNotEmpty
              ? DateTime.tryParse(json["first_air_date"]) ?? DateTime(2000)
              : DateTime(2000),
      genres:
          json["genres"] != null
              ? List<TvGenre>.from(json["genres"].map((x) => TvGenre.fromJson(x)))
              : [],
      homepage: json["homepage"] ?? "",
      id: json["id"] ?? 0,
      inProduction: json["in_production"] ?? false,
      languages:
          json["languages"] != null ? List<String>.from(json["languages"].map((x) => x)) : [],
      lastAirDate:
          json["last_air_date"] != null && json["last_air_date"].isNotEmpty
              ? DateTime.tryParse(json["last_air_date"]) ?? DateTime(2000)
              : DateTime(2000),
      lastEpisodeToAir: LastEpisodeToAir.fromJson(json["last_episode_to_air"]),
      name: json["name"] ?? "",
      nextEpisodeToAir:
          json["next_episode_to_air"] != null
              ? LastEpisodeToAir.fromJson(json["next_episode_to_air"])
              : null,
      numberOfEpisodes: json["number_of_episodes"] ?? 0,
      numberOfSeasons: json["number_of_seasons"] ?? 0,
      originCountry:
          json["origin_country"] != null
              ? List<String>.from(json["origin_country"].map((x) => x))
              : [],
      originalLanguage: json["original_language"] ?? "",
      originalName: json["original_name"] ?? "",
      overview: json["overview"] ?? "",
      popularity: (json["popularity"] is num) ? json["popularity"].toDouble() : 0.0,
      posterPath: json["poster_path"] ?? "",
      seasons:
          json["seasons"] != null
              ? List<Season>.from(json["seasons"].map((x) => Season.fromJson(x)))
              : [],
      status: getStatus(json["status"]),
      tagline: json["tagline"] ?? "",
      type: json["type"] ?? "",
      voteAverage: (json["vote_average"] is num) ? json["vote_average"].toDouble() : 0.0,
      voteCount: json["vote_count"] ?? 0,
    );
  }

  static String getStatus(String? status) {
    if (status == null) return '';
    switch (status) {
      case 'Returning Series':
        return 'Serie que regresa';
      case 'Planned':
        return 'Prevista';
      case 'In Production':
        return 'En producción';
      case 'Ended':
        return 'Terminada';
      case 'Canceled':
        return 'Cancelada';
      case 'Pilot':
        return 'Piloto';
      default:
        return '';
    }
  }
}

class LastEpisodeToAir {
  int id;
  String name;
  String overview;
  double voteAverage;
  int voteCount;
  DateTime airDate;
  int episodeNumber;
  String episodeType;
  String productionCode;
  int runtime;
  int seasonNumber;
  int showId;
  String stillPath;

  LastEpisodeToAir({
    required this.id,
    required this.name,
    required this.overview,
    required this.voteAverage,
    required this.voteCount,
    required this.airDate,
    required this.episodeNumber,
    required this.episodeType,
    required this.productionCode,
    required this.runtime,
    required this.seasonNumber,
    required this.showId,
    required this.stillPath,
  });

  factory LastEpisodeToAir.fromJson(Map<String, dynamic> json) => LastEpisodeToAir(
    id: json["id"],
    name: json["name"],
    overview: json["overview"],
    voteAverage: json["vote_average"]?.toDouble(),
    voteCount: json["vote_count"],
    airDate: DateTime.parse(json["air_date"]),
    episodeNumber: json["episode_number"],
    episodeType: json["episode_type"],
    productionCode: json["production_code"],
    runtime: json["runtime"] ?? 0,
    seasonNumber: json["season_number"],
    showId: json["show_id"],
    stillPath: json["still_path"] ?? '',
  );
}

class Season {
  DateTime? airDate;
  int episodeCount;
  int id;
  String name;
  String overview;
  String posterPath;
  int seasonNumber;
  double voteAverage;

  Season({
    required this.airDate,
    required this.episodeCount,
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.seasonNumber,
    required this.voteAverage,
  });

  factory Season.fromJson(Map<dynamic, dynamic> json) => Season(
    airDate: json["air_date"] != null ? DateTime.parse(json["air_date"]) : null,
    episodeCount: json["episode_count"] ?? 0,
    id: json["id"],
    name: json["name"],
    overview: json["overview"],
    posterPath: json["poster_path"] ?? '',
    seasonNumber: json["season_number"] ?? 0,
    voteAverage: json["vote_average"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "air_date":
        "${airDate?.year.toString().padLeft(4, '0')}-${airDate?.month.toString().padLeft(2, '0')}-${airDate?.day.toString().padLeft(2, '0')}",
    "episode_count": episodeCount,
    "id": id,
    "name": name,
    "overview": overview,
    "poster_path": posterPath,
    "season_number": seasonNumber,
    "vote_average": voteAverage,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Season && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
