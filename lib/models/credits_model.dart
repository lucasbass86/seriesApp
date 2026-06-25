import 'dart:convert';

Credits creditsFromJson(String str) => Credits.fromJson(json.decode(str));

class Credits {
  List<CreditCast> cast;
  List<CreditCast> crew;
  int id;

  Credits({required this.cast, required this.crew, required this.id});

  factory Credits.fromJson(Map<String, dynamic> json) => Credits(
    cast: List<CreditCast>.from(json["cast"].map((x) => CreditCast.fromJson(x))),
    crew: List<CreditCast>.from(json["crew"].map((x) => CreditCast.fromJson(x))),
    id: json["id"],
  );
}

class CreditCast {
  bool adult;
  String? backdropPath;
  List<int> genreIds;
  int id;
  String? originalTitle;
  String overview;
  double popularity;
  String? posterPath;
  String? releaseDate;
  String? title;
  bool? video;
  double voteAverage;
  int voteCount;
  String? character;
  String creditId;
  int? order;
  String? originalName;
  String? firstAirDate;
  String? name;
  int? episodeCount;
  String? firstCreditAirDate;
  String mediaType;
  String? job;
  String? department;

  @override
  String toString() => title ?? originalName ?? name ?? '';

  CreditCast({
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    this.releaseDate,
    this.title,
    this.video,
    required this.voteAverage,
    required this.voteCount,
    this.character,
    required this.creditId,
    this.order,
    required this.mediaType,
    this.originalName,
    this.firstAirDate,
    this.name,
    this.episodeCount,
    this.firstCreditAirDate,
    this.job,
    this.department,
  });

  factory CreditCast.fromJson(Map<String, dynamic> json) => CreditCast(
    adult: json["adult"],
    backdropPath: json["backdrop_path"],
    genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
    id: json["id"],
    originalTitle: json["original_title"],
    overview: json["overview"],
    popularity: json["popularity"]?.toDouble(),
    posterPath: json["poster_path"],
    releaseDate: json["release_date"],
    title: json["title"],
    video: json["video"],
    voteAverage: json["vote_average"]?.toDouble(),
    voteCount: json["vote_count"],
    character: json["character"],
    creditId: json["credit_id"],
    order: json["order"],
    mediaType: json["media_type"] ?? '',
    originalName: json["original_name"],
    firstAirDate: json["first_air_date"] ?? '',
    // firstAirDate:
    //     json["first_air_date"] == null
    //         ? null
    //         : DateTime.parse(json["first_air_date"]),
    name: json["name"],
    episodeCount: json["episode_count"],
    firstCreditAirDate: json["first_credit_air_date"],
    // firstCreditAirDate:
    //     json["first_credit_air_date"] == null
    //         ? null
    //         : DateTime.parse(json["first_credit_air_date"]),
    department: json['department'] ?? '',
    job: json['job'] ?? '',
  );
}
