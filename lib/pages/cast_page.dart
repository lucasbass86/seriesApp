import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:seriesapp/dialogs/dialogs.dart';
import 'package:seriesapp/models/_models.dart';
import 'package:seriesapp/pages/_pages.dart';
import 'package:seriesapp/providers/_providers.dart';
import 'package:seriesapp/services/movie_service.dart';
import 'package:seriesapp/utils/utils.dart';
import 'package:seriesapp/widgets/_widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class CastPage extends StatefulWidget {
  static const String routeName = 'CastPage';
  const CastPage({super.key});

  @override
  State<CastPage> createState() => _CastPageState();
}

class _CastPageState extends State<CastPage> {
  MovieService movieService = MovieService();
  DateTime? lastMovie;
  DateTime? lastTv;
  DateTime? lastCrew;
  Person? person;
  List<Backdrop> images = [];
  List<Backdrop> taggedImages = [];
  late Credits credits;
  late int castId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      movieService = Provider.of(context, listen: false);
      castId = ModalRoute.of(context)!.settings.arguments as int;
      await _getData();
      //INSERTAR EL HISTORICO:
      if (context.mounted) {
        HistoricProvider historicProvider = Provider.of<HistoricProvider>(context, listen: false);
        historicProvider.addHistoric(person!.name, mediaType: 'person', idMediaType: person!.id);
      }
      setState(() {});
    });
  }

  Future<void> _getData() async {
    person = await movieService.getPerson(castId);
    images = await movieService.getPersonImages(castId);
    taggedImages = await movieService.getPersonTaggedImages(castId);
    credits = await movieService.getPersonCredits(person!.id);
  }

  @override
  Widget build(BuildContext context) {
    if (person == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Cargando información . . .'),
          backgroundColor: Utils.naranjaClarito,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: const [
          _AppBar(),
          _MainInfo(),
          _Biography(),
          _Credits(),
          _Images(),
          _TaggedImages(),
          _BottomButtons(),
        ],
      ),
    );
  }
}

class _Biography extends StatelessWidget {
  const _Biography();

  @override
  Widget build(BuildContext context) {
    final Person? person = context.findAncestorStateOfType<_CastPageState>()!.person;
    return person!.biography.isNotEmpty
        ? SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text('Información', style: TextStyle(fontSize: 25)),
                Text(person.biography, textAlign: TextAlign.justify),
                const SizedBox(height: 20),
              ],
            ),
          ),
        )
        : SliverToBoxAdapter();
  }
}

class _MainInfo extends StatelessWidget {
  const _MainInfo();

  @override
  Widget build(BuildContext context) {
    final List<Backdrop> images = context.findAncestorStateOfType<_CastPageState>()!.images;
    final Person? person = context.findAncestorStateOfType<_CastPageState>()!.person;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            person!.profilePath.isNotEmpty
                ? GestureDetector(
                  onTap:
                      () => Navigator.pushNamed(
                        context,
                        ImagesPage.routeName,
                        arguments: [images.map((b) => b.filePath).toList(), 0, person.name],
                      ),
                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(20),
                    child: CachedNetworkImage(
                      imageUrl: 'https://image.tmdb.org/t/p/original${images[0].filePath}',
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
                  ),
                )
                : Icon(Icons.no_photography_rounded, size: 75),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(person.name, style: TextStyle(fontSize: 25)),
                  const SizedBox(height: 10),
                  if (person.birthday != null)
                    Row(
                      spacing: 10,
                      children: [
                        Icon(Icons.calendar_month),
                        Text(Utils.dateEnglishToSpanish(person.birthday.toString())),
                        if (person.deathday == null)
                          Text('(${Utils.calcularEdad(person.birthday!)})'),
                      ],
                    ),
                  if (person.deathday != null)
                    Row(
                      spacing: 10,
                      children: [
                        Icon(Icons.sentiment_very_dissatisfied),
                        Text(Utils.dateEnglishToSpanish(person.deathday.toString())),
                        Text(
                          '(${Utils.calcularEdad(person.birthday!, otherDate: person.deathday)})',
                        ),
                      ],
                    ),
                  if (person.placeOfBirth.isNotEmpty)
                    Wrap(children: [Icon(Icons.location_on), Text(person.placeOfBirth)]),
                  GestureDetector(
                    onTap:
                        () async => await launchUrl(
                          Uri.parse('https://www.google.com/search?q=${person.name}'),
                        ),
                    child: Row(spacing: 5, children: [Icon(Icons.link), Text('Más información')]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    final Person? person = context.findAncestorStateOfType<_CastPageState>()!.person;
    return SliverAppBar(
      backgroundColor: Utils.naranjaClarito,
      flexibleSpace: FlexibleSpaceBar(
        title: GestureDetector(onTap: () => Navigator.pop(context), child: Text(person!.name)),
      ),
    );
  }
}

class _Credits extends StatelessWidget {
  const _Credits();

  @override
  Widget build(BuildContext context) {
    final Person? person = context.findAncestorStateOfType<_CastPageState>()!.person;
    final Credits credits = context.findAncestorStateOfType<_CastPageState>()!.credits;

    DateTime? lastMovie;
    DateTime? lastTv;
    DateTime? lastCrew;
    List<CreditCast> uniqueCrewList = [];

    for (CreditCast cast in credits.crew) {
      if (!uniqueCrewList.contains(credits.crew.firstWhere((c) => c.id == cast.id))) {
        uniqueCrewList.add(cast);
      }
    }
    List<CreditCast> tv = credits.cast.where((c) => c.mediaType == 'tv').toList();
    List<CreditCast> movie = credits.cast.where((c) => c.mediaType == 'movie').toList();
    credits.crew = uniqueCrewList;
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
      CreditCast c = credits.crew.firstWhere((t) {
        if (t.mediaType == 'tv') {
          return t.firstAirDate != null;
        } else {
          return t.releaseDate != null;
        }
      });
      lastCrew =
          c.mediaType == 'tv'
              ? c.firstAirDate!.isNotEmpty
                  ? DateTime.parse(c.firstAirDate!)
                  : null
              : c.releaseDate!.isNotEmpty
              ? DateTime.parse(c.releaseDate!)
              : null;
    }
    _markLastCredits(context, person!, lastTv, lastMovie, lastCrew);
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (movie.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Películas', style: TextStyle(fontSize: 25)),
                      Text('(${movie.length})', style: TextStyle(fontSize: 25)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 150,
                    child: ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(20),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: movie.length,
                        itemBuilder:
                            (context, index) => CreditWidget(credit: movie[index], showType: false),
                      ),
                    ),
                  ),
                ],
              ),
            if (tv.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('TV', style: TextStyle(fontSize: 25)),
                      Text('(${tv.length})', style: TextStyle(fontSize: 25)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 150,
                    child: ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(20),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: tv.length,
                        itemBuilder:
                            (context, index) => CreditWidget(credit: tv[index], showType: false),
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
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 150,
                    child: ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(20),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: credits.crew.length,
                        itemBuilder: (context, index) => CreditWidget(credit: credits.crew[index]),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _markLastCredits(
    BuildContext context,
    Person person,
    DateTime? lastTv,
    DateTime? lastMovie,
    DateTime? lastCrew,
  ) async {
    FollowingProvider provider = Provider.of(context);
    FavoriteModel? favorite = provider.containsFavorite(person.id);
    if (favorite != null) {
      favorite.lastTV = lastTv ?? favorite.lastTV;
      favorite.lastMovie = lastMovie ?? favorite.lastMovie;
      favorite.lastCrew = lastCrew ?? favorite.lastCrew;
      provider.updateFavorite(favorite);
    }
  }
}

class _Images extends StatelessWidget {
  const _Images();

  @override
  Widget build(BuildContext context) {
    final List<Backdrop> images = context.findAncestorStateOfType<_CastPageState>()!.images;
    final Person? person = context.findAncestorStateOfType<_CastPageState>()!.person;
    return SliverToBoxAdapter(
      child: Container(
        height: 200,
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Imágenes', style: TextStyle(fontSize: 25)),
                Text('(${images.length})', style: TextStyle(fontSize: 25)),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(20),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    Backdrop backdrop = images[index];
                    double size = backdrop.aspectRatio < 1 ? 100 : 270;
                    return ImageWidget(
                      height: size / backdrop.aspectRatio,
                      width: size,
                      index: index,
                      title: person!.name,
                      urls: images.map((b) => b.filePath).toList(),
                      imageUrl: 'https://image.tmdb.org/t/p/original/${backdrop.filePath}',
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(width: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaggedImages extends StatelessWidget {
  const _TaggedImages();

  @override
  Widget build(BuildContext context) {
    final List<Backdrop> taggedImages =
        context.findAncestorStateOfType<_CastPageState>()!.taggedImages;
    final Person? person = context.findAncestorStateOfType<_CastPageState>()!.person;

    return taggedImages.isNotEmpty
        ? SliverToBoxAdapter(
          child: Container(
            height: 200,
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Imágenes etiquetadas', style: TextStyle(fontSize: 25)),
                    Text('(${taggedImages.length})', style: TextStyle(fontSize: 25)),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(20),
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: taggedImages.length,
                      itemBuilder: (context, index) {
                        Backdrop backdrop = taggedImages[index];
                        double size = backdrop.aspectRatio < 1 ? 100 : 270;
                        return ImageWidget(
                          height: size / backdrop.aspectRatio,
                          width: size,
                          index: index,
                          title: person!.name,
                          urls: taggedImages.map((b) => b.filePath).toList(),
                          imageUrl: 'https://image.tmdb.org/t/p/original/${backdrop.filePath}',
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(width: 10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        : SliverToBoxAdapter();
  }
}

class _BottomButtons extends StatefulWidget {
  const _BottomButtons();

  @override
  State<_BottomButtons> createState() => _BottomButtonsState();
}

class _BottomButtonsState extends State<_BottomButtons> {
  @override
  Widget build(BuildContext context) {
    final Person? person = context.findAncestorStateOfType<_CastPageState>()!.person;
    final DateTime? lastTv = context.findAncestorStateOfType<_CastPageState>()!.lastTv;
    final DateTime? lastMovie = context.findAncestorStateOfType<_CastPageState>()!.lastMovie;
    final DateTime? lastCrew = context.findAncestorStateOfType<_CastPageState>()!.lastCrew;

    FollowingProvider provider = Provider.of(context);
    FavoriteModel? favorite = provider.containsFavorite(person!.id);
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (favorite != null)
              ButtonWidget(
                text: 'Eliminar',
                onTap: () async {
                  final unlock = await showSlideToUnlock(
                    context,
                    backColor: Utils.naranjaClarito,
                    slideColor: Utils.naranjaPrincipal,
                    textColor: Colors.black,
                  );
                  if (unlock) {
                    await provider.removeFavorite(favorite);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        Utils.snackBar('Eliminado de la lista de favoritos', isGood: false),
                      );
                    }
                    setState(() {});
                  }
                },
                isGood: false,
              ),
            if (favorite == null)
              ButtonWidget(
                text: 'Añadir',
                onTap: () async {
                  FavoriteModel favoriteModel = FavoriteModel(
                    id: Uuid().v4(),
                    person: person,
                    lastTV: lastTv,
                    lastMovie: lastMovie,
                    lastCrew: lastCrew,
                  );
                  await provider.addFavorite(favoriteModel);
                  if (context.mounted) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(Utils.snackBar('Agregado a la lista de favoritos'));
                  }
                  setState(() {});
                },
              ),
          ],
        ),
      ),
    );
  }
}
