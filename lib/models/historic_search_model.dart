class HistoricSearchModel {
  late String id;
  late String search;
  late DateTime dateTime;
  String? mediaType;
  int? idMediaType;

  @override
  String toString() => search;

  HistoricSearchModel({
    required this.id,
    required this.search,
    required this.dateTime,
    this.mediaType,
    this.idMediaType,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'search': search,
      'dateTime': dateTime.toIso8601String(),
      'mediaType': mediaType,
      'idMediaType': idMediaType,
    };
  }

  factory HistoricSearchModel.fromJson(Map<dynamic, dynamic> json) {
    return HistoricSearchModel(
      id: json['id'],
      search: json['search'],
      dateTime: DateTime.parse(json['dateTime']),
      mediaType: json['mediaType'],
      idMediaType: json['idMediaType'],
    );
  }
}
