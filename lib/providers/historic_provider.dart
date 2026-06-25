import 'package:flutter/material.dart';
import 'package:seriesapp/models/_models.dart';
import 'package:seriesapp/utils/utils.dart';
import 'package:uuid/uuid.dart';
export 'package:provider/provider.dart';

class HistoricProvider extends ChangeNotifier {
  List<HistoricSearchModel> historicSearch = [];

  Future<void> addHistoric(String query, {String? mediaType, int? idMediaType}) async {
    if (!hasHistoric(query)) {
      HistoricSearchModel h = HistoricSearchModel(
        id: Uuid().v4(),
        search: query,
        dateTime: DateTime.now(),
        mediaType: mediaType,
        idMediaType: idMediaType,
      );
      historicSearch.add(h);
      await Utils.boxHistoric.put(h.id, h.toJson());
    } else {
      HistoricSearchModel historicSearchModel = historicSearch.firstWhere((h) => h.search == query);
      historicSearchModel.dateTime = DateTime.now();
      await Utils.boxHistoric.put(historicSearchModel.id, historicSearchModel.toJson());
    }
    orderHistoric();
    notifyListeners();
  }

  Future<void> removeHistoric(HistoricSearchModel historic) async {
    await Utils.boxHistoric.delete(historic.id);
    historicSearch.remove(historic);
    orderHistoric();
    notifyListeners();
  }

  bool hasHistoric(String query) => historicSearch.any((h) => h.search == query);

  void orderHistoric() => historicSearch.sort((a, b) => b.dateTime.compareTo(a.dateTime));

  void removeAll() async {
    historicSearch.clear();
    await Utils.boxHistoric.deleteAll(Utils.boxHistoric.keys);
    notifyListeners();
  }
}
