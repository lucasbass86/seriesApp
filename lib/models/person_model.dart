// To parse this JSON data, do
//
//     final person = personFromJson(jsonString);

import 'dart:convert';

Person personFromJson(String str) => Person.fromJson(json.decode(str));

class Person {
  bool adult;
  List<String> alsoKnownAs;
  String biography;
  DateTime? birthday;
  DateTime? deathday;
  int gender;
  String? homepage;
  int id;
  String imdbId;
  String knownForDepartment;
  String name;
  String placeOfBirth;
  double popularity;
  String profilePath;

  @override
  String toString() => name;

  Person({
    required this.adult,
    required this.alsoKnownAs,
    required this.biography,
    required this.birthday,
    required this.deathday,
    required this.gender,
    required this.homepage,
    required this.id,
    required this.imdbId,
    required this.knownForDepartment,
    required this.name,
    required this.placeOfBirth,
    required this.popularity,
    required this.profilePath,
  });

  factory Person.fromJson(Map<dynamic, dynamic> json) => Person(
    adult: json["adult"],
    alsoKnownAs:
        json["also_known_as"] != null ? List<String>.from(json["also_known_as"].map((x) => x)) : [],
    biography: json["biography"] ?? '',
    birthday:
        json["birthday"] != null
            ? json["birthday"] is DateTime
                ? json["birthday"]
                : DateTime.parse(json["birthday"])
            : null,
    deathday:
        json["deathday"] != null
            ? json["deathday"] is DateTime
                ? json["deathday"]
                : DateTime.parse(json["deathday"])
            : null,
    gender: json["gender"],
    homepage: json["homepage"] ?? '',
    id: json["id"],
    imdbId: json["imdb_id"] ?? '',
    knownForDepartment: json["known_for_department"] ?? '',
    name: json["name"],
    placeOfBirth: json["place_of_birth"] ?? '',
    popularity: json["popularity"]?.toDouble(),
    profilePath: json["profile_path"] ?? '',
  );

  Map<String, dynamic> toJson() {
    return {
      'adult': adult,
      'also_known_as': alsoKnownAs,
      'biography': biography,
      'birthday': birthday?.toIso8601String(),
      'deathday': deathday?.toIso8601String(),
      'gender': gender,
      'homepage': homepage,
      'id': id,
      'imdb_id': imdbId,
      'known_for_department': knownForDepartment,
      'name': name,
      'place_of_birth': placeOfBirth,
      'popularity': popularity,
      'profile_path': profilePath,
    };
  }
}
