import 'dart:convert';

Backdrops backdropsFromJson(String str) => Backdrops.fromJson(json.decode(str));

class Backdrops {
  List<Backdrop> backdrops;
  int id;
  List<Backdrop> logos;
  List<Backdrop> posters;

  Backdrops({
    required this.backdrops,
    required this.id,
    required this.logos,
    required this.posters,
  });

  factory Backdrops.fromJson(Map<String, dynamic> json) => Backdrops(
    backdrops: List<Backdrop>.from(
      json["backdrops"].map((x) => Backdrop.fromJson(x)),
    ),
    id: json["id"],
    logos: List<Backdrop>.from(json["logos"].map((x) => Backdrop.fromJson(x))),
    posters: List<Backdrop>.from(
      json["posters"].map((x) => Backdrop.fromJson(x)),
    ),
  );
}

class Backdrop {
  double aspectRatio;
  int? height;
  String? iso6391;
  String filePath;
  double voteAverage;
  int? voteCount;
  int? width;

  Backdrop({
    required this.aspectRatio,
    required this.height,
    required this.iso6391,
    required this.filePath,
    required this.voteAverage,
    required this.voteCount,
    required this.width,
  });

  factory Backdrop.fromJson(Map<String, dynamic> json) => Backdrop(
    aspectRatio: json["aspect_ratio"]?.toDouble(),
    height: json["height"] ?? 0,
    iso6391: json["iso_639_1"],
    filePath: json["file_path"],
    voteAverage: json["vote_average"]?.toDouble() ?? 0,
    voteCount: json["vote_count"] ?? 0,
    width: json["width"] ?? 0,
  );
}
