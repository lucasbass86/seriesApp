import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:seriesapp/models/_models.dart';
import 'package:seriesapp/services/movie_service.dart';
import 'package:seriesapp/widgets/_widgets.dart';

class TopPage extends StatefulWidget {
  const TopPage({super.key});

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  MovieService movieService = MovieService();
  final ScrollController _scrollTV = ScrollController();
  final ScrollController _scrollMovie = ScrollController();
  final ScrollController _scrollPeople = ScrollController();
  int _currentPageTV = 1;
  int _currentPageMovie = 1;
  int _currentPagePeople = 1;
  bool _isLoadingTV = false;
  bool _isLoadingMovie = false;
  bool _isLoadingPeople = false;
  bool _hasMoreTV = true;
  bool _hasMoreMovie = true;
  bool _hasMorePeople = true;
  List<BaseModel> _tv = [];
  List<BaseModel> _movies = [];
  List<Person> _people = [];

  @override
  void initState() {
    super.initState();
    _loadMoreItemsTV();
    _loadMoreItemsMovie();
    _loadMoreItemsPeople();

    _scrollTV.addListener(() {
      if (_scrollTV.position.pixels >= _scrollTV.position.maxScrollExtent - 300 &&
          !_isLoadingTV &&
          _hasMoreTV) {
        _loadMoreItemsTV();
      }
    });
    _scrollMovie.addListener(() {
      if (_scrollMovie.position.pixels >= _scrollMovie.position.maxScrollExtent - 300 &&
          !_isLoadingMovie &&
          _hasMoreMovie) {
        _loadMoreItemsMovie();
      }
    });
    _scrollPeople.addListener(() {
      if (_scrollPeople.position.pixels >= _scrollPeople.position.maxScrollExtent - 300 &&
          !_isLoadingPeople &&
          _hasMorePeople) {
        _loadMoreItemsPeople();
      }
    });
  }

  @override
  void dispose() {
    _scrollTV.dispose();
    _scrollMovie.dispose();
    _scrollPeople.dispose();
    super.dispose();
  }

  Future<void> _loadMoreItemsTV() async {
    if (_isLoadingTV || !_hasMoreTV) return;
    setState(() => _isLoadingTV = true);

    try {
      final newItems = await movieService.getTopTV(_currentPageTV);
      setState(() {
        if (newItems.isEmpty) {
          _hasMoreTV = false;
        } else {
          if (_currentPageTV != 1) {
            _tv.addAll(newItems);
          } else {
            _tv = newItems;
          }
          _currentPageTV++;
        }
        _isLoadingTV = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingTV = false;
      });
    }
  }

  Future<void> _loadMoreItemsMovie() async {
    if (_isLoadingMovie || !_hasMoreMovie) return;
    setState(() => _isLoadingMovie = true);

    try {
      final newItems = await movieService.getTopMovie(_currentPageMovie);
      setState(() {
        if (newItems.isEmpty) {
          _hasMoreMovie = false;
        } else {
          if (_currentPageMovie != 1) {
            _movies.addAll(newItems);
          } else {
            _movies = newItems;
          }
          _currentPageMovie++;
        }
        _isLoadingMovie = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingMovie = false;
      });
    }
  }

  Future<void> _loadMoreItemsPeople() async {
    if (_isLoadingPeople || !_hasMoreMovie) return;
    setState(() => _isLoadingPeople = true);

    try {
      final newItems = await movieService.getTopPerson(_currentPagePeople);
      setState(() {
        if (newItems.isEmpty) {
          _hasMorePeople = false;
        } else {
          if (_currentPagePeople != 1) {
            _people.addAll(newItems);
          } else {
            _people = newItems;
          }
          _currentPagePeople++;
        }
        _isLoadingPeople = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingPeople = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _topTV(movieService, context),
            const SizedBox(height: 20),
            _topMovie(movieService, context),
            const SizedBox(height: 20),
            _topPerson(movieService),
          ],
        ),
      ),
    );
  }

  Widget _topTV(MovieService movieService, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Top TV', style: TextStyle(fontSize: 25)),
        const SizedBox(height: 20),
        SizedBox(
          height: 150,
          child: ListView.builder(
            itemCount: _tv.length,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            controller: _scrollTV,
            itemBuilder: (context, index) {
              BaseModel model = _tv[index];
              CreditCast credit = CreditCast(
                adult: model.adult,
                backdropPath: model.backdropPath,
                genreIds: model.genreIds,
                id: model.id,
                overview: model.overview,
                popularity: model.popularity,
                posterPath: model.posterPath,
                voteAverage: model.voteAverage,
                voteCount: model.voteCount,
                creditId: '',
                mediaType: model.mediaType,
                name: model.name,
                originalName: model.originalName,
              );
              return ZoomIn(child: CreditWidget(credit: credit, showType: false));
            },
          ),
        ),
      ],
    );
  }

  Widget _topMovie(MovieService movieService, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Top Películas', style: TextStyle(fontSize: 25)),
        const SizedBox(height: 20),
        SizedBox(
          height: 150,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: _movies.length,
            controller: _scrollMovie,
            itemBuilder: (context, index) {
              BaseModel model = _movies[index];
              CreditCast credit = CreditCast(
                adult: model.adult,
                backdropPath: model.backdropPath,
                genreIds: model.genreIds,
                id: model.id,
                overview: model.overview,
                popularity: model.popularity,
                posterPath: model.posterPath,
                voteAverage: model.voteAverage,
                voteCount: model.voteCount,
                creditId: '',
                mediaType: model.mediaType,
                name: model.name,
                originalName: model.originalName,
              );
              return ZoomIn(child: CreditWidget(credit: credit, showType: false));
            },
          ),
        ),
      ],
    );
  }

  Widget _topPerson(MovieService movieService) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Top Actores', style: TextStyle(fontSize: 25)),
        const SizedBox(height: 20),
        SizedBox(
          height: 150,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            controller: _scrollPeople,
            itemCount: _people.length,
            itemBuilder: (context, index) {
              Person model = _people[index];
              Cast cast = Cast(
                adult: model.adult,
                gender: model.gender,
                id: model.id,
                name: model.name,
                originalName: '',
                popularity: model.popularity,
                profilePath: model.profilePath,
                creditId: '',
                knownForDepartment: model.knownForDepartment,
              );
              return ZoomIn(child: CastWidget(cast: cast));
            },
          ),
        ),
      ],
    );
  }
}
