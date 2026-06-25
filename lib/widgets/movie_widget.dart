import 'package:flutter/material.dart';
import 'package:seriesapp/models/_models.dart';
import 'package:seriesapp/pages/_pages.dart';
import 'package:seriesapp/utils/utils.dart';

class MovieWidget extends StatelessWidget {
  final BaseModel movie;
  const MovieWidget({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _onTap(movie, context),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.all(20),
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(20),
              child:
                  movie.posterPath.isNotEmpty
                      ? Image.network(
                        'https://image.tmdb.org/t/p/original/${movie.posterPath}',
                        fit: BoxFit.fitHeight,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const SizedBox(
                            width: 300,
                            height: 400,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        },
                      )
                      : Image.asset('assets/no_image.jpg', fit: BoxFit.fitHeight),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 13,
                shadowColor: Utils.naranjaClarito,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  width: 300,
                  child: Text(
                    movie.name,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTap(BaseModel movie, BuildContext context) {
    if (movie.mediaType == 'movie') {
      Navigator.pushNamed(context, MovieDetailPage.routeName, arguments: movie);
    } else if (movie.mediaType == 'tv') {
      Navigator.pushNamed(context, TVDetailPage.routeName, arguments: movie);
    } else if (movie.mediaType == 'person') {
      Navigator.pushNamed(context, CastPage.routeName, arguments: movie.id);
    }
  }
}
