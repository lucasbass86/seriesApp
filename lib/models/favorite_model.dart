import 'package:seriesapp/models/_models.dart';

class FavoriteModel {
  String id;
  Person person;
  DateTime? lastTV;
  DateTime? lastMovie;
  DateTime? lastCrew;

  @override
  String toString() => person.name;

  FavoriteModel({
    required this.id,
    required this.person,
    this.lastTV,
    this.lastMovie,
    this.lastCrew,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'person': person.toJson(),
      'lastTV': lastTV?.toIso8601String(),
      'lastMovie': lastMovie?.toIso8601String(),
      'lastCrew': lastCrew?.toIso8601String(),
    };
  }

  factory FavoriteModel.fromJson(Map<dynamic, dynamic> json) {
    return FavoriteModel(
      id: json['id'],
      person: Person.fromJson(json['person']),
      lastTV: json['lastTV'] != null ? DateTime.parse((json['lastTV'])) : null,
      lastMovie: json['lastMovie'] != null ? DateTime.parse(json['lastMovie']) : null,
      lastCrew: json['lastCrew'] != null ? DateTime.parse(json['lastCrew']) : null,
    );
  }
}
