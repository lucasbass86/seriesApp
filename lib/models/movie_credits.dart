import 'dart:convert';

import 'package:seriesapp/models/_models.dart';

MovieCredits movieCreditsFromJson(String str) => MovieCredits.fromJson(json.decode(str));

class MovieCredits {
  int id;
  List<Cast> cast;
  List<Cast> crew;

  MovieCredits({required this.id, required this.cast, required this.crew});

  factory MovieCredits.fromJson(Map<String, dynamic> json) => MovieCredits(
    id: json["id"],
    cast: List<Cast>.from(json["cast"].map((x) => Cast.fromJson(x))),
    crew: List<Cast>.from(json["crew"].map((x) => Cast.fromJson(x))),
  );
}
