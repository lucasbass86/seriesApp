import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:seriesapp/dialogs/dialogs.dart';
import 'package:seriesapp/models/_models.dart';
import 'package:seriesapp/pages/_pages.dart';
import 'package:seriesapp/providers/_providers.dart';
import 'package:seriesapp/services/movie_service.dart';
import 'package:seriesapp/utils/utils.dart';
import 'package:seriesapp/widgets/_widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class TVDetailPage extends StatefulWidget {
  static const String routeName = 'TVDetailPage';
  const TVDetailPage({super.key});

  @override
  State<TVDetailPage> createState() => _TVDetailPageState();
}

class _TVDetailPageState extends State<TVDetailPage> {
  late MovieService movieService;
  BaseModel? baseModel;
  TvModel? tv;
  MovieCredits? credits;
  Backdrops? backdrops;
  List<BaseModel>? similars;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      baseModel = ModalRoute.of(context)!.settings.arguments as BaseModel;
      movieService = Provider.of<MovieService>(context, listen: false);
      await _getData();
      //INSERTAR EL HISTORICO:
      if (context.mounted) {
        // ignore: use_build_context_synchronously
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

  Future<String> _getData() async {
    credits = await movieService.getCredits2(baseModel!);
    backdrops = await movieService.getBackdrops(baseModel!);
    similars = await movieService.getSimilar(baseModel!, 1);
    tv = await movieService.getTVDetail(baseModel!.id);
    return '';
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
        slivers: const [
          _AppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  _MainInfo(),
                  SizedBox(height: 20),
                  _Overview(),
                  SizedBox(height: 20),
                  _Genres(),
                  SizedBox(height: 20),
                  _Cast(),
                  SizedBox(height: 20),
                  _Backdrops(),
                  _Similar(),
                  _TvDetail(),
                  _BottomButtons(),
                  SizedBox(height: 20),
                ],
              ),
            ),
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
    final baseModel = context.findAncestorStateOfType<_TVDetailPageState>()!.baseModel;
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

class _Overview extends StatelessWidget {
  const _Overview();

  @override
  Widget build(BuildContext context) {
    final baseModel = (context.findAncestorStateOfType<_TVDetailPageState>()!.baseModel);
    return baseModel!.overview.isNotEmpty
        ? Text(baseModel.overview, textAlign: TextAlign.justify)
        : const SizedBox.shrink();
  }
}

class _MainInfo extends StatelessWidget {
  const _MainInfo();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_Poster(), const SizedBox(width: 10), _Info()],
    );
  }
}

class _Genres extends StatelessWidget {
  const _Genres();

  @override
  Widget build(BuildContext context) {
    final state = context.findAncestorStateOfType<_TVDetailPageState>()!;
    final baseModel = state.baseModel;
    final movieService = state.movieService;
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children:
          baseModel!.genreIds.map((g) {
            TvGenre genre =
                baseModel.mediaType == 'tv'
                    ? movieService.tvGenres.firstWhere((e) => e.id == g)
                    : movieService.movieGenres.firstWhere((e) => e.id == g);
            return GenreWidget(genre: genre);
          }).toList(),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info();

  @override
  Widget build(BuildContext context) {
    final baseModel = context.findAncestorStateOfType<_TVDetailPageState>()!.baseModel;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(baseModel!.name, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 10),
          Row(
            children: [
              RatingBarIndicator(
                rating: baseModel.voteAverage / 2,
                itemBuilder: (context, index) => const Icon(Icons.star, color: Colors.amber),
                itemCount: 5,
                itemSize: 20,
                direction: Axis.horizontal,
              ),
              Text(baseModel.voteCount.toString()),
            ],
          ),
          const SizedBox(height: 10),
          if (baseModel.firstAirDate != null)
            Row(
              children: [
                const Icon(Icons.calendar_month),
                Text(Utils.dateEnglishToSpanish(baseModel.firstAirDate.toString())),
              ],
            ),
          GestureDetector(
            onTap:
                () async =>
                    await launchUrl(Uri.parse('https://www.google.com/search?q=${baseModel.name}')),
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
    final baseModel = context.findAncestorStateOfType<_TVDetailPageState>()!.baseModel;
    final String url = 'https://image.tmdb.org/t/p/original/${baseModel!.posterPath}';
    return GestureDetector(
      onTap:
          () => Navigator.pushNamed(
            context,
            ImagesPage.routeName,
            arguments: [
              [url],
              0,
              baseModel.name,
            ],
          ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: CachedNetworkImage(
          imageUrl: url,
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
                padding: const EdgeInsets.all(10),
                child: Center(child: CircularProgressIndicator()),
              ),
          errorWidget:
              (context, url, error) => Container(
                width: 150,
                padding: const EdgeInsets.all(10),
                child: Icon(Icons.error),
              ),
        ),
      ),
    );
  }
}

class _Cast extends StatelessWidget {
  const _Cast();

  @override
  Widget build(BuildContext context) {
    final state = context.findAncestorStateOfType<_TVDetailPageState>()!;
    final credits = state.credits;
    if (credits == null) return const SizedBox.shrink();

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
                  const Text('Cast', style: TextStyle(fontSize: 25)),
                  Text('(${credits.cast.length})', style: const TextStyle(fontSize: 25)),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
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
                  const Text('Crew', style: TextStyle(fontSize: 25)),
                  Text('(${credits.crew.length})', style: const TextStyle(fontSize: 25)),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
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
  }
}

class _BottomButtons extends StatelessWidget {
  const _BottomButtons();

  @override
  Widget build(BuildContext context) {
    final state = context.findAncestorStateOfType<_TVDetailPageState>()!;
    final baseModel = state.baseModel;
    final tv = state.tv;
    final FollowingProvider provider = Provider.of(context);
    final FollowingModel? following = provider.containsFollowing(baseModel!.id);

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
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    context: context,
                    builder: (context) {
                      final TextEditingController hoursController = TextEditingController(
                        text: '0',
                      );
                      final TextEditingController minutesController = TextEditingController(
                        text: '0',
                      );
                      Season? season = tv != null ? tv.seasons[0] : null;
                      int? chapter = 1;

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
                                  decoration: const BoxDecoration(
                                    color: Utils.naranjaClarito,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                  child: const Center(
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
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Flexible(
                                              flex: 1,
                                              child: DropdownButton(
                                                underline: Container(),
                                                borderRadius: BorderRadius.circular(20),
                                                dropdownColor: Utils.naranjaSecundario,
                                                value: season,
                                                items:
                                                    tv?.seasons
                                                        .map(
                                                          (s) => DropdownMenuItem(
                                                            value: s,
                                                            child: Text(s.name),
                                                          ),
                                                        )
                                                        .toList() ??
                                                    [],
                                                onChanged: <Season>(value) {
                                                  setState(() {
                                                    season = value!;
                                                    chapter = 1;
                                                  });
                                                },
                                              ),
                                            ),
                                            if (season != null)
                                              Flexible(
                                                flex: 1,
                                                child: DropdownButton(
                                                  underline: Container(),
                                                  borderRadius: BorderRadius.circular(20),
                                                  dropdownColor: Utils.naranjaSecundario,
                                                  value: chapter,
                                                  items: List.generate(
                                                    season!.episodeCount,
                                                    (index) => DropdownMenuItem(
                                                      value: index + 1,
                                                      child: Text('Capítulo ${index + 1}'),
                                                    ),
                                                  ),
                                                  onChanged: (value) {
                                                    setState(() => chapter = value!);
                                                  },
                                                ),
                                              ),
                                            if (season == null)
                                              const Flexible(flex: 1, child: SizedBox()),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Column(
                                              children: [
                                                const Text('Hora'),
                                                NumericUpDownWidget(
                                                  controller: hoursController,
                                                  minValue: 0,
                                                  maxValue: 10,
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                const Text('Minuto'),
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
                                        const Expanded(child: SizedBox(height: 1)),
                                        ButtonWidget(
                                          text: 'Aceptar',
                                          onTap: () {
                                            final follow = FollowingModel(
                                              id: const Uuid().v4(),
                                              model: baseModel,
                                            );
                                            follow.hour = int.parse(hoursController.text);
                                            follow.minute = int.parse(minutesController.text);
                                            follow.selectedChapter = chapter;
                                            follow.seasons = tv?.seasons;
                                            follow.selectedSeason = season;
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

class _TvDetail extends StatelessWidget {
  const _TvDetail();

  @override
  Widget build(BuildContext context) {
    final state = context.findAncestorStateOfType<_TVDetailPageState>()!;
    final tv = state.tv;
    if (tv == null) return const SizedBox.shrink();

    if (tv.seasons.isNotEmpty && tv.seasons[0].name == 'Especiales') {
      tv.seasons.removeAt(0);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text('Temporadas', style: TextStyle(fontSize: 25)),
        Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(top: 20, bottom: 20),
          width: double.infinity,
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
                  if (tv.type.isNotEmpty)
                    Row(
                      children: [
                        const Text('Tipo: '),
                        Text(tv.type, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  if (tv.homepage.isNotEmpty)
                    GestureDetector(
                      onTap: () async => await launchUrl(Uri.parse(tv.homepage)),
                      child: const Icon(Icons.link),
                    ),
                ],
              ),
              Row(
                children: [
                  const Text('Estado: '),
                  Text(tv.status, style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              if (tv.lastAirDate != null)
                Row(
                  children: [
                    const Text('Último capítulo: '),
                    Text(
                      Utils.dateEnglishToSpanish(tv.lastAirDate.toString()),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              if (tv.nextEpisodeToAir != null)
                Row(
                  children: [
                    const Text('Siguiente capítulo: '),
                    Text(
                      Utils.dateEnglishToSpanish(tv.nextEpisodeToAir!.airDate.toString()),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              if (tv.tagline.isNotEmpty)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Eslogan: '),
                    Expanded(
                      child: Text(tv.tagline, style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text('Temporada', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text('Capítulos', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text('Puntuación', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Expanded(flex: 1, child: SizedBox(width: 15)),
                ],
              ),
              ...tv.seasons.map(
                (s) => InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    if (s.overview.isNotEmpty) {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          final String url = 'https://image.tmdb.org/t/p/original/${s.posterPath}';
                          return SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap:
                                          () => Navigator.pushNamed(
                                            context,
                                            ImagesPage.routeName,
                                            arguments: [
                                              [url],
                                              0,
                                              state.baseModel!.name,
                                            ],
                                          ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: SizedBox(
                                          width: 150,
                                          height: 200,
                                          child: Image.network(
                                            url,
                                            fit: BoxFit.cover,
                                            loadingBuilder: (context, child, loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return const SizedBox(
                                                width: 300,
                                                height: 400,
                                                child: Center(child: CircularProgressIndicator()),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(s.overview, textAlign: TextAlign.justify),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    child: Row(
                      children: [
                        Expanded(flex: 3, child: Text(s.name)),
                        Expanded(flex: 2, child: Text(s.episodeCount.toString())),
                        Expanded(
                          flex: 3,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: RatingBarIndicator(
                              rating: s.voteAverage / 2,
                              itemBuilder:
                                  (context, index) => const Icon(Icons.star, color: Colors.amber),
                              itemCount: 5,
                              itemSize: 20,
                              direction: Axis.horizontal,
                            ),
                          ),
                        ),
                        if (s.overview.isNotEmpty)
                          const Expanded(flex: 1, child: Icon(Icons.info_outline_rounded)),
                        if (s.overview.isEmpty) const Expanded(flex: 1, child: SizedBox(width: 15)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Backdrops extends StatelessWidget {
  const _Backdrops();

  @override
  Widget build(BuildContext context) {
    final state = context.findAncestorStateOfType<_TVDetailPageState>()!;
    final backdrops = state.backdrops;
    if (backdrops == null || backdrops.backdrops.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Imágenes', style: TextStyle(fontSize: 25)),
              Text('(${backdrops.backdrops.length})', style: const TextStyle(fontSize: 25)),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final backdrop = backdrops.backdrops[index];
                  final double size = backdrop.aspectRatio < 1 ? 100 : 270;
                  return ZoomIn(
                    child: ImageWidget(
                      height: size / backdrop.aspectRatio,
                      width: size,
                      index: index,
                      title: state.baseModel!.name,
                      urls: backdrops.backdrops.map((b) => b.filePath).toList(),
                      imageUrl: 'https://image.tmdb.org/t/p/original/${backdrop.filePath}',
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
  }
}

class _Similar extends StatelessWidget {
  const _Similar();

  @override
  Widget build(BuildContext context) {
    final state = context.findAncestorStateOfType<_TVDetailPageState>()!;
    final similars = state.similars;
    if (similars == null || similars.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Similares', style: TextStyle(fontSize: 25)),
            Text('(${similars.length})', style: const TextStyle(fontSize: 25)),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 150,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: similars.length,
              itemBuilder: (context, index) {
                final model = similars[index];
                final credit = CreditCast(
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
    );
  }
}
