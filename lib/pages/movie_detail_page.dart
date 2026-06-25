import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:seriesapp/dialogs/dialogs.dart';
import 'package:seriesapp/models/_models.dart';
import 'package:seriesapp/pages/_pages.dart';
import 'package:seriesapp/providers/_providers.dart';
import 'package:seriesapp/providers/following_provider.dart';
import 'package:seriesapp/services/movie_service.dart';
import 'package:seriesapp/utils/utils.dart';
import 'package:seriesapp/widgets/_widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class MovieDetailPage extends StatefulWidget {
  static const String routeName = 'MovieDetailPage';
  const MovieDetailPage({super.key});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  BaseModel? baseModel;
  late MovieService movieService;
  MovieModel? movie;
  MovieCollectionModel? collectionModel;
  MovieCredits? credits;
  Backdrops? backdrops;
  List<BaseModel>? similars;
  TvModel? tv;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      baseModel = ModalRoute.of(context)!.settings.arguments as BaseModel;
      movieService = Provider.of(context, listen: false);
      await _getData();
      //INSERTAR EL HISTORICO:
      if (context.mounted) {
        HistoricProvider historicProvider = Provider.of<HistoricProvider>(context, listen: false);
        historicProvider.addHistoric(
          baseModel!.name,
          mediaType: baseModel!.mediaType,
          idMediaType: baseModel!.id,
        );
      }
      setState(() {});
    });
  }

  Future<void> _getData() async {
    movie = await movieService.getMovieDetail(baseModel!.id);
    if (movie != null && movie!.belongsToCollection != null) {
      collectionModel = await movieService.getMovieCollection(movie!.belongsToCollection!.id);
    }
    credits = await movieService.getCredits2(baseModel!);
    backdrops = await movieService.getBackdrops(baseModel!);
    similars = await movieService.getSimilar(baseModel!, 1);
  }

  @override
  Widget build(BuildContext context) {
    if (baseModel == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Cargando información . . .'),
          backgroundColor: Utils.naranjaClarito,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _AppBar(),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [_Poster(), SizedBox(width: 10), _Info()],
                    ),
                    SizedBox(height: 20),
                    _OverView(),
                    SizedBox(height: 20),
                    _Genres(),
                    SizedBox(height: 20),
                    _Cast(),
                    SizedBox(height: 20),
                    _Backdrops(),
                    SizedBox(height: 20),
                    _Similars(),
                    SizedBox(height: 20),
                    _MovieDetails(),
                    SizedBox(height: 20),
                    _BottomButton(),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    final baseModel = context.findAncestorStateOfType<_MovieDetailPageState>()!.baseModel;
    return SliverAppBar(
      expandedHeight: baseModel!.backdropPath.isNotEmpty ? 200 : 40,
      pinned: false,
      backgroundColor: Utils.naranjaClarito,
      flexibleSpace: FlexibleSpaceBar(
        background:
            baseModel.backdropPath.isNotEmpty
                ? GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: CachedNetworkImage(
                    imageUrl: 'https://image.tmdb.org/t/p/original/${baseModel.backdropPath}',
                    imageBuilder:
                        (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                    placeholder:
                        (context, url) => Container(
                          padding: const EdgeInsets.all(10),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                    errorWidget:
                        (context, url, error) =>
                            Container(padding: const EdgeInsets.all(10), child: Icon(Icons.error)),
                  ),
                )
                : AppBar(
                  title: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(baseModel.name),
                  ),
                  backgroundColor: Utils.naranjaClarito,
                ),
      ),
    );
  }
}

class _OverView extends StatelessWidget {
  const _OverView();

  @override
  Widget build(BuildContext context) {
    BaseModel? baseModel = context.findAncestorStateOfType<_MovieDetailPageState>()!.baseModel;
    return Text(baseModel!.overview, textAlign: TextAlign.justify);
  }
}

class _Genres extends StatelessWidget {
  const _Genres();

  @override
  Widget build(BuildContext context) {
    BaseModel? movie = context.findAncestorStateOfType<_MovieDetailPageState>()!.baseModel;
    MovieService movieService =
        context.findAncestorStateOfType<_MovieDetailPageState>()!.movieService;
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        ...movie!.genreIds.map((g) {
          TvGenre genre = movieService.movieGenres.firstWhere((e) => e.id == g);
          return GenreWidget(genre: genre);
        }),
      ],
    );
  }
}

class _MovieDetails extends StatelessWidget {
  const _MovieDetails();

  @override
  Widget build(BuildContext context) {
    MovieModel? movie = context.findAncestorStateOfType<_MovieDetailPageState>()!.movie;
    MovieCollectionModel? collection =
        context.findAncestorStateOfType<_MovieDetailPageState>()?.collectionModel;
    if (collection != null) {
      collection.parts.sort((a, b) => a.id.compareTo(b.id));
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Utils.naranjaSecundario),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (movie!.status.isNotEmpty)
                  Row(
                    spacing: 10,
                    children: [
                      Text('Estado:'),
                      Text(movie.status, style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                if (movie.homepage.isNotEmpty)
                  GestureDetector(
                    onTap: () async => await launchUrl(Uri.parse(movie.homepage)),
                    child: Icon(Icons.link),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            if (movie.tagline.isNotEmpty)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Text('Eslogan:'),
                  Expanded(
                    child: Text(movie.tagline, style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            if (movie.belongsToCollection != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    collection.name.isNotEmpty ? collection.name : 'Colección',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  if (collection.overview.isNotEmpty)
                    Column(
                      children: [
                        Text(collection.overview, textAlign: TextAlign.justify),
                        const SizedBox(height: 20),
                      ],
                    ),
                  SizedBox(
                    height: 150,
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: collection.parts.length,
                      itemBuilder: (context, index) {
                        BaseModel model = collection.parts[index];
                        CreditCast creditCast = CreditCast(
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
                          firstAirDate: model.firstAirDate.toString(),
                          releaseDate: model.firstAirDate.toString(),
                        );
                        return CreditWidget(credit: creditCast);
                      },
                      separatorBuilder: (BuildContext context, int index) => SizedBox(width: 10),
                    ),
                  ),
                ],
              ),
          ],
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}

class _Info extends StatelessWidget {
  const _Info();

  @override
  Widget build(BuildContext context) {
    BaseModel? movie = context.findAncestorStateOfType<_MovieDetailPageState>()!.baseModel;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(movie!.name, style: TextStyle(fontSize: 20)),
          const SizedBox(height: 10),
          Row(
            children: [
              RatingBarIndicator(
                rating: movie.voteAverage / 2,
                itemBuilder: (context, index) => Icon(Icons.star, color: Colors.amber),
                itemCount: 5,
                itemSize: 20,
                direction: Axis.horizontal,
              ),
              Text(movie.voteCount.toString()),
            ],
          ),
          // Text(movie.id.toString()),
          const SizedBox(height: 10),
          if (movie.firstAirDate != null)
            Row(
              children: [
                Icon(Icons.calendar_month),
                Text(Utils.dateEnglishToSpanish(movie.firstAirDate.toString())),
              ],
            ),
          GestureDetector(
            onTap:
                () async =>
                    await launchUrl(Uri.parse('https://www.google.com/search?q=${movie.name}')),
            child: Row(spacing: 5, children: [Icon(Icons.link), Text('Más información')]),
          ),
        ],
      ),
    );
  }
}

class _Poster extends StatelessWidget {
  const _Poster();

  @override
  Widget build(BuildContext context) {
    BaseModel? movie = context.findAncestorStateOfType<_MovieDetailPageState>()!.baseModel;
    final String url = 'https://image.tmdb.org/t/p/original/${movie!.posterPath}';
    return GestureDetector(
      onTap:
          () => Navigator.pushNamed(
            context,
            ImagesPage.routeName,
            arguments: [
              [url],
              0,
              movie.name,
            ],
          ),
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(20),
        child: SizedBox(
          width: 150,
          height: 200,
          child: CachedNetworkImage(
            imageUrl: 'https://image.tmdb.org/t/p/original$url',
            imageBuilder:
                (context, imageProvider) => Container(
                  width: 150,
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
            placeholder:
                (context, url) => Container(
                  width: 150,
                  height: 200,
                  padding: const EdgeInsets.all(10),
                  child: Center(child: CircularProgressIndicator()),
                ),
            errorWidget:
                (context, url, error) => Container(
                  width: 150,
                  height: 200,
                  padding: const EdgeInsets.all(10),
                  child: Icon(Icons.error),
                ),
          ),
          //  Image.network(
          //   url,
          //   fit: BoxFit.cover,
          //   loadingBuilder: (context, child, loadingProgress) {
          //     if (loadingProgress == null) return child;
          //     return const SizedBox(
          //       width: 300,
          //       height: 400,
          //       child: Center(child: CircularProgressIndicator()),
          //     );
          //   },
          // ),
        ),
      ),
    );
  }
}

class _Cast extends StatelessWidget {
  const _Cast();

  @override
  Widget build(BuildContext context) {
    MovieCredits? credits = context.findAncestorStateOfType<_MovieDetailPageState>()?.credits;
    if (credits != null) {
      List<Cast> uniqueCrewList = [];
      credits.crew.removeWhere((c) => c.knownForDepartment == 'Acting');
      for (Cast cast in credits.crew) {
        if (!uniqueCrewList.contains(credits.crew.firstWhere((c) => c.id == cast.id))) {
          uniqueCrewList.add(cast);
        }
      }
      credits.crew = uniqueCrewList;
      credits.crew.sort((a, b) {
        if (a.knownForDepartment == "Directing" && b.knownForDepartment != "Directing") {
          return -1;
        } else if (a.knownForDepartment != "Directing" && b.knownForDepartment == "Directing") {
          return 1;
        } else {
          return 0;
        }
      });
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (credits.cast.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Cast', style: TextStyle(fontSize: 25)),
                    Text('(${credits.cast.length})', style: TextStyle(fontSize: 25)),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 150,
                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(20),
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: credits.cast.length,
                      itemBuilder:
                          (context, index) => ZoomIn(child: CastWidget(cast: credits.cast[index])),
                    ),
                  ),
                ),
              ],
            ),
          if (credits.crew.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Crew', style: TextStyle(fontSize: 25)),
                    Text('(${credits.crew.length})', style: TextStyle(fontSize: 25)),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 150,
                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(20),
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: credits.crew.length,
                      itemBuilder:
                          (context, index) =>
                              ZoomIn(child: CastWidget(cast: credits.crew[index], showCrew: true)),
                    ),
                  ),
                ),
              ],
            ),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

class _Backdrops extends StatelessWidget {
  const _Backdrops();

  @override
  Widget build(BuildContext context) {
    BaseModel? movie = context.findAncestorStateOfType<_MovieDetailPageState>()!.baseModel;
    Backdrops? backdrops = context.findAncestorStateOfType<_MovieDetailPageState>()?.backdrops;
    if (backdrops != null) {
      if (backdrops.backdrops.isNotEmpty) {
        return SizedBox(
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Imágenes', style: TextStyle(fontSize: 25)),
                  Text('(${backdrops.backdrops.length})', style: TextStyle(fontSize: 25)),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(20),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      Backdrop backdrop = backdrops.backdrops[index];
                      double size = backdrop.aspectRatio < 1 ? 100 : 270;
                      return ZoomIn(
                        child: ImageWidget(
                          height: size / backdrop.aspectRatio,
                          width: size,
                          index: index,
                          title: movie!.name,
                          urls: backdrops.backdrops.map((b) => b.filePath).toList(),
                          imageUrl:
                              'https://image.tmdb.org/t/p/original/${backdrops.backdrops[index].filePath}',
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(width: 10),
                    itemCount: backdrops.backdrops.length,
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        return const SizedBox.shrink();
      }
    } else {
      return const SizedBox.shrink();
    }
  }
}

class _Similars extends StatelessWidget {
  const _Similars();

  @override
  Widget build(BuildContext context) {
    List<BaseModel>? similars = context.findAncestorStateOfType<_MovieDetailPageState>()?.similars;
    if (similars != null) {
      return similars.isNotEmpty
          ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Similares', style: TextStyle(fontSize: 25)),
                  Text('(${similars.length})', style: TextStyle(fontSize: 25)),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 150,
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(20),
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: similars.length,
                    itemBuilder: (context, index) {
                      BaseModel model = similars[index];
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
                        firstAirDate: model.firstAirDate?.toString(),
                        releaseDate: model.firstAirDate?.toString(),
                      );
                      return ZoomIn(child: CreditWidget(credit: credit, showType: false));
                    },
                  ),
                ),
              ),
            ],
          )
          : const SizedBox.shrink();
    } else {
      return const SizedBox.shrink();
    }
  }
}

class _BottomButton extends StatelessWidget {
  const _BottomButton();

  @override
  Widget build(BuildContext context) {
    BaseModel? movie = context.findAncestorStateOfType<_MovieDetailPageState>()!.baseModel;
    FollowingProvider provider = Provider.of(context);
    FollowingModel? following = provider.containsFollowing(movie!.id);
    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (following != null)
              ButtonWidget(
                text: 'Eliminar',
                onTap: () async {
                  final unlock = await showSlideToUnlock(
                    context,
                    backColor: Utils.naranjaClarito,
                    slideColor: Utils.naranjaPrincipal,
                    textColor: Colors.black,
                  );
                  if (unlock && context.mounted) {
                    provider.removeFollowing(following.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      Utils.snackBar('Eliminada de la lista de seguir', isGood: false),
                    );
                  }
                },
                isGood: false,
              ),
            if (following == null)
              ButtonWidget(
                text: 'Añadir',
                onTap: () {
                  showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    context: context,
                    builder: (context) {
                      TextEditingController hoursController = TextEditingController(text: '0');
                      TextEditingController minutesController = TextEditingController(text: '0');
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return SizedBox(
                            height: 300,
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 70,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Utils.naranjaClarito,
                                    borderRadius: BorderRadiusGeometry.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Indica por dónde vas',
                                      style: TextStyle(fontSize: 25),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Column(
                                              children: [
                                                Text('Hora'),
                                                NumericUpDownWidget(
                                                  controller: hoursController,
                                                  minValue: 0,
                                                  maxValue: 10,
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text('Minuto'),
                                                NumericUpDownWidget(
                                                  controller: minutesController,
                                                  minValue: 0,
                                                  maxValue: 60,
                                                  onChange: (value) {
                                                    setState(() {
                                                      if (value == 60) {
                                                        minutesController.text = '0';
                                                        hoursController.text =
                                                            (int.parse(hoursController.text) + 1)
                                                                .toString();
                                                      }
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Expanded(child: SizedBox(height: 1)),
                                        ButtonWidget(
                                          text: 'Aceptar',
                                          onTap: () {
                                            FollowingModel follow = FollowingModel(
                                              id: Uuid().v4(),
                                              model: movie,
                                            );
                                            follow.hour = int.parse(hoursController.text);
                                            follow.minute = int.parse(minutesController.text);
                                            provider.addFollowing(follow);
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              Utils.snackBar('Serie añadida para seguir'),
                                            );
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
          ],
        ),
      ],
    );
  }
}
