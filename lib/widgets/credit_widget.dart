import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:seriesapp/models/_models.dart';
import 'package:seriesapp/pages/_pages.dart';
import 'package:seriesapp/providers/following_provider.dart';
import 'package:seriesapp/services/movie_service.dart';
import 'package:seriesapp/utils/utils.dart';

class CreditWidget extends StatelessWidget {
  final CreditCast credit;
  final bool showType;
  const CreditWidget({super.key, required this.credit, this.showType = true});

  @override
  Widget build(BuildContext context) {
    MovieService movieService = Provider.of(context, listen: false);
    FollowingProvider followingProvider = Provider.of(context, listen: false);
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _onTap(context, movieService),
        child: Container(
          width: 250,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color:
                  followingProvider.containsFollowing(credit.id) != null
                      ? Utils.verde
                      : Utils.naranjaSecundario,
            ),
          ),
          child: Row(
            children: [
              credit.posterPath != null && credit.posterPath!.isNotEmpty
                  ? ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(20),
                    child: CachedNetworkImage(
                      imageUrl: 'https://image.tmdb.org/t/p/original/${credit.posterPath}',
                      imageBuilder:
                          (context, imageProvider) => Container(
                            width: 100,
                            height: 150,
                            decoration: BoxDecoration(
                              image: DecorationImage(image: imageProvider, fit: BoxFit.fitHeight),
                            ),
                          ),
                      placeholder:
                          (context, url) => Container(
                            width: 100,
                            padding: const EdgeInsets.all(10),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                      errorWidget:
                          (context, url, error) => Container(
                            width: 100,
                            padding: const EdgeInsets.all(10),
                            child: Icon(Icons.error),
                          ),
                    ),
                    // Image.network(
                    //   'https://image.tmdb.org/t/p/original/${credit.posterPath}',
                    //   fit: BoxFit.fitHeight,
                    //   width: 100,
                    //   height: 150,
                    //   loadingBuilder: (context, child, loadingProgress) {
                    //     if (loadingProgress == null) return child;
                    //     return Container(
                    //       width: 100,
                    //       padding: const EdgeInsets.all(10),
                    //       child: Center(child: CircularProgressIndicator()),
                    //     );
                    //   },
                    // ),
                  )
                  : Center(child: Icon(Icons.no_photography_rounded, size: 75)),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (credit.mediaType == 'movie')
                        if (credit.releaseDate != null &&
                            credit.releaseDate!.isNotEmpty &&
                            credit.releaseDate != 'null')
                          Text(Utils.dateEnglishToSpanish(credit.releaseDate.toString())),
                      if (credit.mediaType == 'tv')
                        if (credit.firstAirDate != null && credit.firstAirDate!.isNotEmpty)
                          Text(Utils.dateEnglishToSpanish(credit.firstAirDate.toString())),
                      Text(
                        credit.title ??
                            credit.originalTitle ??
                            credit.name ??
                            credit.originalName ??
                            '',
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (credit.character != null)
                        Text(credit.character ?? '', overflow: TextOverflow.ellipsis),
                      RatingBarIndicator(
                        rating: credit.popularity / 2,
                        itemBuilder: (context, index) => Icon(Icons.star, color: Colors.amber),
                        itemCount: 5,
                        itemSize: 20,
                        direction: Axis.horizontal,
                      ),
                      // if (showType) Text(credit.mediaType == 'movie' ? 'Película' : 'TV'),
                      if (credit.department != null && credit.department!.isNotEmpty)
                        Text(credit.department.toString(), overflow: TextOverflow.ellipsis),
                      // if (credit.job != null && credit.job!.isNotEmpty)
                      //   Text(credit.job.toString(), overflow: TextOverflow.ellipsis),
                      const Expanded(child: SizedBox(height: 1)),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text('+ info', style: TextStyle(color: Colors.lightBlue)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTap(BuildContext context, MovieService movieService) async {
    late BaseModel baseModel;
    if (credit.mediaType == 'tv') {
      TvModel tv = await movieService.getTVDetail(credit.id);
      baseModel = BaseModel(
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
    } else {
      MovieModel movie = await movieService.getMovieDetail(credit.id);
      baseModel = BaseModel(
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
    }
  }
}
