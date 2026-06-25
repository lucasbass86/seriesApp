import 'dart:convert';

List<BaseModel> movieFromJson(String str) =>
    List<BaseModel>.from(json.decode(str).map((x) => BaseModel.fromJson(x)));

class BaseModel {
  bool adult;
  String backdropPath;
  List<int> genreIds;
  int id;
  String originalName;
  String overview;
  double popularity;
  String posterPath;
  DateTime? firstAirDate;
  String name;
  double voteAverage;
  int voteCount;
  String mediaType;

  @override
  String toString() => name;

  BaseModel({
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.firstAirDate,
    required this.name,
    required this.voteAverage,
    required this.voteCount,
    required this.mediaType,
  });

  factory BaseModel.fromJson(Map<String, dynamic> json) => BaseModel(
    adult: json["adult"],
    backdropPath: json["backdrop_path"] ?? '',
    genreIds: json["genre_ids"] != null ? List<int>.from(json["genre_ids"].map((x) => x)) : [],
    id: json["id"],
    originalName: json["original_name"] ?? '',
    overview: json["overview"] ?? '',
    popularity: json["popularity"]?.toDouble(),
    posterPath: json["poster_path"] ?? '',
    firstAirDate:
        json.containsKey('first_air_date')
            ? json["first_air_date"] != ''
                ? DateTime.parse(json["first_air_date"])
                : null
            : json.containsKey('release_date')
            ? json["release_date"] != ''
                ? DateTime.parse(json["release_date"])
                : null
            : null,
    name:
        json.containsKey('name')
            ? json["name"]
            : json.containsKey('title')
            ? json['title']
            : '',
    voteAverage: json["vote_average"]?.toDouble() ?? 0,
    voteCount: json["vote_count"] ?? 0,
    mediaType: json["media_type"] ?? '',
  );

  Map<String, dynamic> toJson() {
    return {
      'adult': adult,
      'backdrop_path': backdropPath,
      'genre_ids': genreIds,
      'id': id,
      'original_name': originalName,
      'overview': overview,
      'popularity': popularity,
      'poster_path': posterPath,
      'first_air_date': firstAirDate?.toIso8601String(),
      'name': name,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'media_type': mediaType,
    };
  }

  BaseModel copyWith({String? type}) {
    return BaseModel(
      mediaType: type ?? mediaType,
      adult: adult,
      backdropPath: backdropPath,
      genreIds: genreIds,
      id: id,
      originalName: originalName,
      overview: overview,
      popularity: popularity,
      posterPath: posterPath,
      firstAirDate: firstAirDate,
      name: name,
      voteAverage: voteAverage,
      voteCount: voteCount,
    );
  }
}
