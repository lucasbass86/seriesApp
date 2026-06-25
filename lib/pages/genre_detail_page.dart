import 'package:flutter/material.dart';
import 'package:seriesapp/models/_models.dart';
import 'package:seriesapp/preferences/preferences.dart';
import 'package:seriesapp/services/movie_service.dart';
import 'package:seriesapp/utils/enum.dart';
import 'package:seriesapp/utils/utils.dart';
import 'package:seriesapp/widgets/_widgets.dart';

class GenreDetailPage extends StatefulWidget {
  static const String routeName = 'GenreDetailPage';
  const GenreDetailPage({super.key});

  @override
  State<GenreDetailPage> createState() => _GenreDetailPageState();
}

class _GenreDetailPageState extends State<GenreDetailPage> {
  final MovieService _movieService = MovieService();
  final CarouselController _scrollController = CarouselController();
  final List<BaseModel> _movies = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  late TvGenre _genre;
  bool _isFirstCall = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300 &&
          !_isLoading &&
          _hasMore) {
        _loadMoreItems();
      }
    });
  }

  Future<void> _loadMoreItems() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final newItems = await _movieService.getByGenre(_genre.id, _currentPage);
      setState(() {
        if (newItems.isEmpty) {
          _hasMore = false;
        } else {
          _movies.addAll(newItems);
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
    _genre = ModalRoute.of(context)!.settings.arguments as TvGenre;
    if (_isFirstCall) {
      _loadMoreItems();
      _isFirstCall = false;
    }
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(onTap: () => Navigator.pop(context), child: Text(_genre.name)),
        backgroundColor: Utils.naranjaClarito,
        actions: [_filter()],
      ),
      body: CarouselView(
        itemExtent: double.infinity,
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        shrinkExtent: 250,
        overlayColor: WidgetStatePropertyAll(Utils.naranjaClarito.withAlpha(170)),
        onTap: null,
        enableSplash: false,
        children: [..._movies.map((m) => MovieWidget(movie: m))],
      ),
    );
  }

  Widget _filter() {
    return Row(
      children: [
        if (Utils.typeFilter == ETypeFilter.tv)
          DropdownButton<EOrderTV>(
            underline: Container(),
            borderRadius: BorderRadius.circular(20),
            dropdownColor: Utils.naranjaClarito,
            value: Utils.orderTV = EOrderTV.values[Preferences.orderTV],
            items:
                EOrderTV.values
                    .map(
                      (ty) => DropdownMenuItem<EOrderTV>(
                        value: ty,
                        child: Text(ty.displayName, style: TextStyle(fontSize: 13)),
                      ),
                    )
                    .toList(),
            onChanged: (value) {
              setState(() {
                Utils.orderTV = value!;
                Preferences.orderTV = EOrderTV.values.indexOf(value);
                _isFirstCall = true;
                _currentPage = 1;
                _movies.clear();
              });
            },
          ),
        if (Utils.typeFilter == ETypeFilter.movie)
          DropdownButton<EOrderMovie>(
            underline: Container(),
            borderRadius: BorderRadius.circular(20),
            dropdownColor: Utils.naranjaClarito,
            value: Utils.orderMovie = EOrderMovie.values[Preferences.orderMovie],
            items:
                EOrderMovie.values
                    .map(
                      (ty) => DropdownMenuItem<EOrderMovie>(
                        value: ty,
                        child: Text(ty.displayName, style: TextStyle(fontSize: 13)),
                      ),
                    )
                    .toList(),
            onChanged: (value) {
              setState(() {
                Utils.orderMovie = value!;
                Preferences.orderMovie = EOrderMovie.values.indexOf(value);
                _isFirstCall = true;
                _currentPage = 1;
                _movies.clear();
              });
            },
          ),
      ],
    );
  }
}
