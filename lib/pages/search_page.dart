import 'package:flutter/material.dart';
import 'package:seriesapp/models/_models.dart';
import 'package:seriesapp/pages/_pages.dart';
import 'package:seriesapp/providers/_providers.dart';
import 'package:seriesapp/services/movie_service.dart';
import 'package:seriesapp/utils/utils.dart';
import 'package:seriesapp/widgets/_widgets.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final MovieService _movieService = MovieService();
  final CarouselController _scrollController = CarouselController();
  List<MultiSeachResult> _movies = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  TextEditingController searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String prevSearch = '';
  late HistoricProvider historicProvider;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      FocusScope.of(context).unfocus();
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300 &&
          !_isLoading &&
          _hasMore) {
        _loadMoreItems();
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _loadMoreItems() async {
    if (_isLoading || !_hasMore) return;
    setState(() => _isLoading = true);

    try {
      final newItems = await _movieService.search(searchController.text, _currentPage);
      setState(() {
        if (newItems.isEmpty && prevSearch == searchController.text) {
          _hasMore = false;
        } else if (newItems.isEmpty && prevSearch != searchController.text) {
          _movies.clear();
        } else {
          prevSearch = searchController.text;
          if (_currentPage != 1) {
            _movies.addAll(newItems);
          } else {
            _movies = newItems;
          }
          _currentPage++;
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    historicProvider = Provider.of<HistoricProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset(Utils.logo),
        backgroundColor: Utils.naranjaClarito,
        title: TextField(
          controller: searchController,
          autofocus: true,
          focusNode: _focusNode,
          maxLength: 50,
          textInputAction: TextInputAction.search,
          onSubmitted: (value) => _search(),
          decoration: InputDecoration(
            hintText: 'Buscar...',
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            hintStyle: TextStyle(color: Utils.naranjaPrincipal),
            counterText: '',
          ),
          style: TextStyle(color: Utils.naranjaPrincipal, fontSize: 16.0),
        ),
        actions: [
          if (searchController.text.isEmpty)
            IconButton(
              icon: Icon(Icons.search, color: Utils.naranjaSecundario),
              onPressed: () => _search(),
            ),
          if (searchController.text.isNotEmpty)
            IconButton(
              icon: Icon(Icons.clear, color: Utils.naranjaSecundario),
              onPressed: () {
                searchController.text = '';
                _isSearching = false;
                _focusNode.requestFocus();
                setState(() {});
              },
            ),
        ],
      ),
      body: !_isSearching ? _listHistoric() : _carousel(),
    );
  }

  Widget _carousel() {
    return CarouselView(
      itemExtent: double.infinity,
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
      shrinkExtent: 250,
      overlayColor: WidgetStatePropertyAll(Utils.naranjaClarito.withAlpha(170)),
      onTap: null,
      enableSplash: false,
      itemSnapping: true,
      children: [
        if (_movies.isNotEmpty)
          ..._movies.map((m) {
            BaseModel movie = BaseModel(
              adult: m.adult,
              backdropPath: m.backdropPath ?? '',
              genreIds: m.genreIds ?? [],
              id: m.id,
              originalName: m.originalName ?? m.originalTitle ?? m.title ?? '',
              overview: m.overview ?? '',
              popularity: m.popularity,
              posterPath: m.posterPath ?? m.profilePath ?? '',
              firstAirDate: m.firstAirDate,
              name: m.title ?? m.name ?? m.originalTitle ?? m.originalName ?? '',
              voteAverage: m.voteAverage ?? 0,
              voteCount: m.voteCount ?? 0,
              mediaType: m.mediaType ?? '',
            );
            return MovieWidget(movie: movie);
          }),
        if (_movies.isEmpty && searchController.text.isNotEmpty)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.movie_creation_rounded, size: 200, color: Utils.naranjaClarito),
              Text(
                'Ninguna coincidencia',
                style: TextStyle(fontSize: 25, color: Utils.naranjaSecundario),
              ),
            ],
          ),
      ],
    );
  }

  Widget _listHistoric() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: historicProvider.historicSearch.length,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemBuilder: (context, index) {
        final HistoricSearchModel historic = historicProvider.historicSearch[index];
        return ListTile(
          title: Text(historic.search, overflow: TextOverflow.ellipsis),
          trailing: GestureDetector(
            onTap: () => historicProvider.removeHistoric(historic),
            child: Icon(Icons.delete, color: Utils.naranjaSecundario),
          ),
          onTap: () async {
            if (historic.mediaType == null) {
              searchController.text = historic.search;
              _search();
            } else if (historic.mediaType == 'movie') {
              MovieService movieService = Provider.of(context, listen: false);
              MovieModel movie = await movieService.getMovieDetail(historic.idMediaType!);
              BaseModel baseModel = BaseModel(
                adult: movie.adult,
                backdropPath: movie.backdropPath,
                genreIds: movie.genres.map((g) => g.id).toList(),
                id: movie.id,
                originalName: movie.originalTitle,
                overview: movie.overview,
                popularity: movie.popularity,
                posterPath: movie.posterPath,
                firstAirDate: movie.releaseDate,
                name: movie.title,
                voteAverage: movie.voteAverage,
                voteCount: movie.voteCount,
                mediaType: 'movie',
              );
              if (context.mounted) {
                Navigator.pushNamed(context, MovieDetailPage.routeName, arguments: baseModel);
              }
            } else if (historic.mediaType == 'tv') {
              MovieService movieService = Provider.of(context, listen: false);
              TvModel tv = await movieService.getTVDetail(historic.idMediaType!);
              BaseModel baseModel = BaseModel(
                adult: tv.adult,
                backdropPath: tv.backdropPath,
                genreIds: tv.genres.map((g) => g.id).toList(),
                id: tv.id,
                originalName: tv.originalName,
                overview: tv.overview,
                popularity: tv.popularity,
                posterPath: tv.posterPath,
                firstAirDate: tv.firstAirDate,
                name: tv.name,
                voteAverage: tv.voteAverage,
                voteCount: tv.voteCount,
                mediaType: 'tv',
              );
              if (context.mounted) {
                Navigator.pushNamed(context, TVDetailPage.routeName, arguments: baseModel);
              }
            } else if (historic.mediaType == 'person') {
              Navigator.pushNamed(context, CastPage.routeName, arguments: historic.idMediaType);
            }
          },
        );
      },
      separatorBuilder: (context, index) => const Divider(color: Utils.naranjaSecundario),
    );
  }

  void _search() {
    _isSearching = true;
    if (searchController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(Utils.snackBar('Introduce el texto a buscar', isGood: false));
      return;
    }
    setState(() {
      //_isLoading = true;
      historicProvider.addHistoric(searchController.text);
      _currentPage = 1;
      _loadMoreItems();
      if (_scrollController.hasClients) {
        if (_scrollController.position.pixels != 0) {
          _scrollController.jumpTo(0);
        }
      }
      FocusScope.of(context).unfocus();
    });
  }
}
