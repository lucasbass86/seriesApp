import 'package:flutter/material.dart';
import 'package:seriesapp/pages/_pages.dart';
import 'package:seriesapp/services/update_service.dart';

Map<String, Widget Function(BuildContext)> routes = <String, WidgetBuilder>{
  HomePage.routeName: (_) => const HomePage(),
  GenreDetailPage.routeName: (_) => const GenreDetailPage(),
  MovieDetailPage.routeName: (_) => const MovieDetailPage(),
  TVDetailPage.routeName: (_) => const TVDetailPage(),
  CastPage.routeName: (_) => const CastPage(),
  ImagesPage.routeName: (_) => const ImagesPage(),
  FavoritePage.routeName: (_) => const FavoritePage(),
  UpdatePage.routeName: (_) => const UpdatePage(),
  NoConnectionPage.routeName: (_) => const NoConnectionPage(),
  SettingsPage.routeName: (_) => const SettingsPage(),
};
