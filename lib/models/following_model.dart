import 'package:seriesapp/models/_models.dart';

class FollowingModel {
  String id;
  int? hour;
  int? minute;
  List<Season>? seasons;
  Season? selectedSeason;
  int? selectedChapter;
  BaseModel model;

  @override
  String toString() => model.name;

  FollowingModel({
    required this.id,
    this.hour,
    this.minute,
    this.seasons,
    this.selectedChapter,
    this.selectedSeason,
    required this.model,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hour': hour,
      'minute': minute,
      'seasons': seasons?.map((x) => x.toJson()).toList(),
      'selectedSeason': selectedSeason?.toJson(),
      'selectedChapter': selectedChapter,
      'model': model.toJson(),
    };
  }

  factory FollowingModel.fromJson(Map<dynamic, dynamic> json) {
    return FollowingModel(
      id: json['id'],
      hour: json['hour'] ?? 0,
      minute: json['minute'] ?? 0,
      seasons:
          json['seasons'] != null
              ? List<Season>.from(json['seasons']?.map((x) => Season.fromJson(x)))
              : null,
      selectedSeason:
          json['selectedSeason'] != null ? Season.fromJson(json['selectedSeason']) : null,
      selectedChapter: json['selectedChapter'] ?? 0,
      model: BaseModel.fromJson(Map<String, dynamic>.from(json['model'])),
    );
  }
}
