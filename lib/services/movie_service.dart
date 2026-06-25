import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:seriesapp/models/_models.dart';
import 'package:http/http.dart' as http;
import 'package:seriesapp/preferences/preferences.dart';
import 'package:seriesapp/secret/secret.dart';
import 'package:seriesapp/utils/enum.dart';
import 'package:seriesapp/utils/utils.dart';
export 'package:provider/provider.dart';

class MovieService with ChangeNotifier {
  final String key = Secret.movieDBKey;
  final String bearer = Secret.movieDBbearer;

  final String urlBase = 'https://api.themoviedb.org/3/';

  final String language = 'language=es-ES';
  final String apiKey = '&api_key=';
  String adult = '&include_adult=${Preferences.adulto}';

  List<TvGenre> tvGenres = [];
  List<TvGenre> movieGenres = [];

  void updateListeners() {
    notifyListeners();
  }

  Future<List<Person>> getTopPerson(int page) async {
    final url = Uri.parse('$urlBase/trending/person/week?$language$apiKey$key&page=$page');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $bearer', 'accept': 'application/json'},
    );
    final personList = jsonDecode(response.body)['results'] as List<dynamic>;
    List<Person> persons = personList.map((m) => Person.fromJson(m)).toList();
    return persons;
  }

  Future<List<BaseModel>> getTopMovie(int page) async {
    final url = Uri.parse('${urlBase}trending/movie/week?$language$adult$apiKey$key&page=$page');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $bearer', 'accept': 'application/json'},
    );
    final moviesList = jsonDecode(response.body)['results'] as List<dynamic>;
    List<BaseModel> movies = moviesList.map((m) => BaseModel.fromJson(m)).toList();
    return movies;
  }

  Future<List<BaseModel>> getTopTV(int page) async {
    final url = Uri.parse('${urlBase}trending/tv/week?$language$adult$apiKey$key&page=$page');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $bearer', 'accept': 'application/json'},
    );
    final moviesList = jsonDecode(response.body)['results'] as List<dynamic>;
    List<BaseModel> movies = moviesList.map((m) => BaseModel.fromJson(m)).toList();
    return movies;
  }

  Future<List<BaseModel>> getSimilar(BaseModel model, int page) async {
    final url = Uri.parse(
      '$urlBase${model.mediaType}/${model.id}/similar?$language$apiKey$key&page=$page',
    );
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $bearer', 'accept': 'application/json'},
    );
    final moviesList = jsonDecode(response.body)['results'] as List<dynamic>;
    String type = model.mediaType;
    List<BaseModel> similar =
        moviesList.map((m) {
          final model = BaseModel.fromJson(m);
          return model.copyWith(type: type);
        }).toList();
    return similar;
  }

  Future<List<MultiSeachResult>> search(String query, int page) async {
    final url = Uri.parse(
      '${urlBase}search/multi?$language$adult$apiKey$key&page=$page&query=$query',
    );
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $bearer', 'accept': 'application/json'},
    );
    final moviesList = jsonDecode(response.body)['results'] as List<dynamic>;
    List<MultiSeachResult> movies = moviesList.map((m) => MultiSeachResult.fromJson(m)).toList();
    return movies;
  }

  Future<void> getTvGenres() async {
    final url = Uri.parse('${urlBase}genre/tv/list?$language$key$key');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $bearer', 'accept': 'application/json'},
    );
    final genresList = jsonDecode(response.body)['genres'] as List<dynamic>;
    tvGenres = genresList.map((genre) => TvGenre.fromJson(genre)).toList();
    notifyListeners();
  }

  Future<void> getMovieGenres() async {
    final url = Uri.parse('${urlBase}genre/movie/list?$language$key$key');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $bearer', 'accept': 'application/json'},
    );
    final genresList = jsonDecode(response.body)['genres'] as List<dynamic>;
    movieGenres = genresList.map((genre) => TvGenre.fromJson(genre)).toList();
    notifyListeners();
  }

  Future<List<BaseModel>> getByGenre(int idGenre, int page) async {
    Utils.orderMovie = EOrderMovie.values[Preferences.orderMovie];
    Utils.orderTV = EOrderTV.values[Preferences.orderTV];
    final url = Uri.parse(
      '${urlBase}discover/${Utils.typeFilter == ETypeFilter.tv ? 'tv' : 'movie'}?$language$adult$apiKey$key&page=$page&sort_by=${Utils.typeFilter == ETypeFilter.tv ? Utils.orderTV.apiName : Utils.orderMovie.apiName}&with_genres=$idGenre',
    );
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $bearer', 'accept': 'application/json'},
    );
    final moviesList = jsonDecode(response.body)['results'] as List<dynamic>;
    final modifiedMoviesList =
        moviesList.map((m) {
          return {
            ...m as Map<String, dynamic>,
            'media_type': Utils.typeFilter == ETypeFilter.tv ? 'tv' : 'movie',
          };
        }).toList();
    List<BaseModel> movies = modifiedMoviesList.map((m) => BaseModel.fromJson(m)).toList();

    return movies;
  }

  Future<MovieCredits> getCredits2(BaseModel model) async {
    final url = Uri.parse(
      '$urlBase${model.mediaType == 'tv' ? 'tv' : 'movie'}/${model.id}/credits?$language$apiKey$key',
    );
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $bearer', 'accept': 'application/json'},
    );
    final creditsList = jsonDecode(response.body);
    MovieCredits credits = MovieCredits.fromJson(creditsList);
    return credits;
  }

  Future<TvModel> getTVDetail(int id) async {
    final url = Uri.parse('$urlBase/tv/$id?$language$apiKey$key');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $bearer', 'accept': 'application/json'},
    );
    final detail = jsonDecode(response.body);
    TvModel tv = TvModel.fromJson(detail);
    return tv;
  }

  Future<MovieModel> getMovieDetail(int id) async {
    final url = Uri.parse('$urlBase/movie/$id?$language$apiKey$key');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $bearer', 'accept': 'application/json'},
    );
    final detail = jsonDecode(response.body);
    MovieModel movie = MovieModel.fromJson(detail);
    return movie;
  }

  Future<MovieCollectionModel> getMovieCollection(int id) async {
    final url = Uri.parse('$urlBase/collection/$id?$language$apiKey$key');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $bearer', 'accept': 'application/json'},
    );
    final detail = jsonDecode(response.body);
    MovieCollectionModel collection = MovieCollectionModel.fromJson(detail);
    return collection;
  }

  Future<Person> getPerson(int id) async {
    final url = Uri.parse('$urlBase/person/$id?$language$apiKey$key');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $bearer', 'accept': 'application/json'},
    );
    final detail = jsonDecode(response.body);
    Person person = Person.fromJson(detail);
    return person;
  }

  Future<Credits> getPersonCredits(int id) async {
    final url = Uri.parse('${urlBase}person/$id/combined_credits?$language$apiKey$key');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $bearer', 'accept': 'application/json'},
    );
    final detail = jsonDecode(response.body);
    Credits credits = Credits.fromJson(detail);
    return credits;
  }

  Future<Backdrops> getBackdrops(BaseModel model) async {
    final url = Uri.parse('$urlBase${model.mediaType == 'tv' ? 'tv' : 'movie'}/${model.id}/images');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $bearer', 'accept': 'application/json'},
    );
    final detail = jsonDecode(response.body);
    Backdrops backdrops = Backdrops.fromJson(detail);
    return backdrops;
  }

  Future<List<Backdrop>> getPersonImages(int id) async {
    final url = Uri.parse('${urlBase}person/$id/images');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $bearer', 'accept': 'application/json'},
    );
    final List<dynamic> detail = jsonDecode(response.body)['profiles'] as List<dynamic>;
    List<Backdrop> backdrops =
        detail.map((m) => Backdrop.fromJson(m as Map<String, dynamic>)).toList();
    return backdrops;
  }

  Future<List<Backdrop>> getPersonTaggedImages(int id, {int page = 1}) async {
    List<Backdrop> allBackdrops = [];
    int page = 1;
    bool hasMorePages = true;

    while (hasMorePages) {
      final url = Uri.parse('${urlBase}person/$id/tagged_images?page=$page');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $bearer', 'accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final List<dynamic> detail = jsonResponse['results'] as List<dynamic>;
        final int totalPages = jsonResponse['total_pages'] as int;
        List<Backdrop> backdrops =
            detail.map((m) => Backdrop.fromJson(m as Map<String, dynamic>)).toList();
        allBackdrops.addAll(backdrops);
        if (page >= totalPages) {
          hasMorePages = false;
        } else {
          page++;
        }
      } else {
        throw Exception('Failed to load images: ${response.statusCode}');
      }
    }
    return allBackdrops;
  }
}
