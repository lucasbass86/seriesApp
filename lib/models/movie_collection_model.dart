import 'dart:convert';

import 'package:seriesapp/models/_models.dart';

MovieCollectionModel movieCollectionModelFromJson(String str) =>
    MovieCollectionModel.fromJson(json.decode(str));

class MovieCollectionModel {
  int id;
  String name;
  String overview;
  String posterPath;
  String backdropPath;
  List<BaseModel> parts;

  MovieCollectionModel({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.parts,
  });

  factory MovieCollectionModel.fromJson(Map<String, dynamic> json) => MovieCollectionModel(
    id: json["id"],
    name: json["name"],
    overview: json["overview"],
    posterPath: json["poster_path"],
    backdropPath: json["backdrop_path"],
    parts: List<BaseModel>.from(json["parts"].map((x) => BaseModel.fromJson(x))),
  );
}
