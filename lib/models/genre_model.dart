// To parse this JSON data, do
//
//     final genre = genreFromJson(jsonString);

import 'dart:convert';

List<TvGenre> genreFromJson(String str) =>
    List<TvGenre>.from(json.decode(str).map((x) => TvGenre.fromJson(x)));

class TvGenre {
  int id;
  String name;

  @override
  String toString() => name;

  TvGenre({required this.id, required this.name});

  factory TvGenre.fromJson(Map<String, dynamic> json) =>
      TvGenre(id: json["id"], name: json["name"]);
}
