import 'package:flutter/material.dart';
import 'package:seriesapp/models/_models.dart';
import 'package:seriesapp/services/movie_service.dart';
import 'package:seriesapp/utils/utils.dart';
export 'package:provider/provider.dart';

class FollowingProvider with ChangeNotifier {
  List<FollowingModel> following = [];
  List<FavoriteModel> favorites = [];

  Future<void> loadFollowing() async {
    notifyListeners();
  }

  Future<void> addFollowing(FollowingModel follow) async {
    following.add(follow);
    await Utils.boxFollowing.put(follow.id, follow.toJson());
    notifyListeners();
  }

  Future<void> removeFollowing(String id) async {
    following.removeWhere((f) => f.id == id);
    await Utils.boxFollowing.delete(id);
    notifyListeners();
  }

  FollowingModel? containsFollowing(int id) {
    FollowingModel? contains;
    for (FollowingModel follow in following) {
      if (follow.model.id == id) {
        contains = follow;
        break;
      }
    }
    return contains;
  }

  Future<void> updateFollowing(
    FollowingModel following, {
    Season? selectedSeason,
    int? selectedChapter,
    int? hour,
    int? minute,
  }) async {
    following.selectedSeason = selectedSeason ?? following.selectedSeason;
    following.selectedChapter = selectedChapter ?? following.selectedChapter;
    following.hour = hour ?? following.hour;
    following.minute = minute ?? following.minute;
    await Utils.boxFollowing.put(following.id, following.toJson());
    notifyListeners();
  }

  Future<void> addFavorite(FavoriteModel favorite) async {
    favorites.add(favorite);
    await Utils.boxFavorites.put(favorite.id.toString(), favorite.toJson());
    notifyListeners();
  }

  Future<void> removeFavorite(FavoriteModel favorite) async {
    favorites.removeWhere((p) => p.id == favorite.id);
    await Utils.boxFavorites.delete(favorite.id);
    notifyListeners();
  }

  FavoriteModel? containsFavorite(int id) {
    FavoriteModel? contains;
    for (FavoriteModel favorite in favorites) {
      if (favorite.person.id == id) {
        contains = favorite;
        break;
      }
    }
    return contains;
  }

  Future<void> updateFavorite(FavoriteModel favorite) async {
    favorites[favorites.indexWhere((f) => f.id == favorite.id)] = favorite;
    await Utils.boxFavorites.put(favorite.id, favorite.toJson());
  }

  Future<List<FavoriteModel>> newCredits(BuildContext context) async {
    MovieService movieService = Provider.of(context, listen: false);
    DateTime? lastTv;
    DateTime? lastMovie;
    DateTime? lastCrew;
    List<FavoriteModel> favs = [];
    for (FavoriteModel f in favorites) {
      Credits credits = await movieService.getPersonCredits(f.person.id);
      List<CreditCast> tv = credits.cast.where((c) => c.mediaType == 'tv').toList();
      List<CreditCast> movie = credits.cast.where((c) => c.mediaType == 'movie').toList();

      tv.sort((a, b) {
        if (a.firstAirDate != null && b.firstAirDate != null) {
          return b.firstAirDate!.compareTo(a.firstAirDate!);
        } else if (a.firstAirDate != null) {
          return -1;
        } else if (b.firstAirDate != null) {
          return 1;
        }
        if (a.firstCreditAirDate != null && b.firstCreditAirDate != null) {
          return b.firstCreditAirDate!.compareTo(a.firstCreditAirDate!);
        } else if (a.firstCreditAirDate != null) {
          return -1;
        } else if (b.firstCreditAirDate != null) {
          return 1;
        }
        return 0;
      });
      movie.sort((a, b) {
        if (a.releaseDate != null && b.releaseDate != null) {
          return b.releaseDate!.compareTo(a.releaseDate!);
        } else if (a.releaseDate != null) {
          return -1;
        } else if (b.releaseDate != null) {
          return 1;
        }
        if (a.firstAirDate != null && b.firstAirDate != null) {
          return b.firstAirDate!.compareTo(a.firstAirDate!);
        } else if (a.firstAirDate != null) {
          return -1;
        } else if (b.firstAirDate != null) {
          return 1;
        }
        if (a.firstCreditAirDate != null && b.firstCreditAirDate != null) {
          return b.firstCreditAirDate!.compareTo(a.firstCreditAirDate!);
        } else if (a.firstCreditAirDate != null) {
          return -1;
        } else if (b.firstCreditAirDate != null) {
          return 1;
        }
        return 0;
      });
      credits.crew.sort((a, b) {
        if (a.releaseDate != null && b.releaseDate != null) {
          return b.releaseDate!.compareTo(a.releaseDate!);
        } else if (a.releaseDate != null) {
          return -1;
        } else if (b.releaseDate != null) {
          return 1;
        }
        if (a.firstAirDate != null && b.firstAirDate != null) {
          return b.firstAirDate!.compareTo(a.firstAirDate!);
        } else if (a.firstAirDate != null) {
          return -1;
        } else if (b.firstAirDate != null) {
          return 1;
        }
        if (a.firstCreditAirDate != null && b.firstCreditAirDate != null) {
          return b.firstCreditAirDate!.compareTo(a.firstCreditAirDate!);
        } else if (a.firstCreditAirDate != null) {
          return -1;
        } else if (b.firstCreditAirDate != null) {
          return 1;
        }
        return 0;
      });
      if (tv.isNotEmpty) {
        lastTv = DateTime.parse(tv.firstWhere((t) => t.firstAirDate != null).firstAirDate!);
      }
      if (movie.isNotEmpty) {
        lastMovie = DateTime.parse(movie.firstWhere((t) => t.releaseDate != null).releaseDate!);
      }
      if (credits.crew.isNotEmpty) {
        lastCrew = DateTime.parse(
          credits.crew.firstWhere((t) => t.releaseDate != null).releaseDate!,
        );
      }
      if (lastTv != null && f.lastTV != null) {
        if (lastTv.isAfter(f.lastTV!)) {
          favs.add(f);
          continue;
        }
      }
      if (lastMovie != null && f.lastMovie != null) {
        if (lastMovie.isAfter(f.lastMovie!)) {
          favs.add(f);
          continue;
        }
      }
      if (lastCrew != null && f.lastCrew != null) {
        if (lastCrew.isAfter(f.lastCrew!)) {
          favs.add(f);
          continue;
        }
      }
    }
    return favs;
  }
}
