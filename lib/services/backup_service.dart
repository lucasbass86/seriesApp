import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:seriesapp/models/_models.dart';
import 'package:seriesapp/secret/secret.dart';

class User {
  String email;
  String password;
  List<FollowingModel> following;
  List<FavoriteModel> favorites;

  @override
  String toString() => email;

  User({
    required this.email,
    required this.password,
    required this.favorites,
    required this.following,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    email: json['email'],
    password: json['password'].toString(),
    following: (json['following'] as List).map((e) => FollowingModel.fromJson(e)).toList(),
    favorites: (json['favorites'] as List).map((e) => FavoriteModel.fromJson(e)).toList(),
  );

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'following': (following).map((e) => e.toJson()).toList(),
    'favorites': (favorites).map((e) => e.toJson()).toList(),
  };
}

class BackupService {
  static final _baseUrl = Secret.firebaseUrl;
  static final _appName = 'seriesapp';

  static Future<void> addBackUp(User user) async {
    final String emailKey = user.email.replaceAll('.', ',');
    final url = Uri.https(_baseUrl, '$_appName/$emailKey.json');
    await http.put(url, body: jsonEncode(user.toJson()));
  }

  static Future<User?> getBackUp(String email) async {
    final String emailKey = email.replaceAll('.', ',');
    final url = Uri.https(_baseUrl, '$_appName/$emailKey.json');
    final resp = await http.get(url);
    if (resp.statusCode != 200 || resp.body == 'null') {
      return null;
    }
    final Map<String, dynamic> data = jsonDecode(resp.body);
    User user = User.fromJson(data);
    return user;
  }

  static Future<void> deleteBackUp(String email) async {
    final String emailKey = email.replaceAll('.', ',');
    final url = Uri.https(_baseUrl, '$_appName/$emailKey.json');
    await http.delete(url);
  }
}
