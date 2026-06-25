import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:seriesapp/models/_models.dart';
import 'package:seriesapp/pages/_pages.dart';
import 'package:seriesapp/preferences/preferences.dart';
import 'package:seriesapp/providers/_providers.dart';
import 'package:seriesapp/routes/routes.dart';
import 'package:seriesapp/services/movie_service.dart';
import 'package:seriesapp/themes/themes.dart';
import 'package:seriesapp/utils/utils.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Preferences.init();
  Utils.path = await getApplicationDocumentsDirectory();
  Hive.init(Utils.path.path);
  await Hive.openBox(Utils.boxFollowingName);
  await Hive.openBox(Utils.boxFavoritesName);
  await Hive.openBox(Utils.boxHistoricSearch);

  bool hasConnection = await Utils.checkConnection();

  FlutterError.onError = (FlutterErrorDetails details) {
    _navigateToErrorPage(details);
  };

  runZonedGuarded(
    () {
      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => MovieService(), lazy: true),
            ChangeNotifierProvider(create: (_) => FollowingProvider(), lazy: true),
            ChangeNotifierProvider(create: (_) => HistoricProvider(), lazy: true),
          ],
          child: hasConnection ? const Home() : const NoConnection(),
        ),
      );
    },
    (error, stackTrace) {
      _navigateToErrorPage(null);
    },
  );
}

void _navigateToErrorPage(FlutterErrorDetails? details) {
  if (navigatorKey.currentContext != null) {
    Navigator.of(navigatorKey.currentContext!).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ErrorPage(errorDetails: details?.exception.toString()),
      ),
    );
  }
}

class NoConnection extends StatelessWidget {
  const NoConnection({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: routes,
      initialRoute: NoConnectionPage.routeName,
      debugShowCheckedModeBanner: false,
      title: 'Series App',
      theme: themeData,
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    MovieService movieService = Provider.of(context, listen: false);
    FollowingProvider followingProvider = Provider.of(context, listen: false);
    HistoricProvider historicProvider = Provider.of(context, listen: false);
    movieService.getTvGenres();
    movieService.getMovieGenres();

    // Utils.boxFollowing.deleteAll(Utils.boxFollowing.keys);
    // Utils.boxFavorites.deleteAll(Utils.boxFavorites.keys);
    // Utils.boxHistoric.deleteAll(Utils.boxHistoric.keys);

    followingProvider.following =
        Utils.boxFollowing.keys.map((e) {
          final value = Utils.boxFollowing.get(e);
          return FollowingModel.fromJson(value);
        }).toList();

    followingProvider.favorites =
        Utils.boxFavorites.keys.map((e) {
          final value = Utils.boxFavorites.get(e);
          return FavoriteModel.fromJson(value);
        }).toList();

    historicProvider.historicSearch =
        Utils.boxHistoric.keys.map((e) {
          final value = Utils.boxHistoric.get(e);
          return HistoricSearchModel.fromJson(value);
        }).toList();
    historicProvider.orderHistoric();

    return MaterialApp(
      routes: routes,
      initialRoute: HomePage.routeName,
      debugShowCheckedModeBanner: false,
      title: 'Series App',
      theme: themeData,
    );
  }
}

class ErrorPage extends StatelessWidget {
  final String? errorDetails;

  const ErrorPage({super.key, this.errorDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Página de Error')),
      body: Center(
        child: Text(
          'Ocurrió un error: ${errorDetails ?? 'Desconocido'}',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
