import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:seriesapp/dialogs/modalbottom.dart';
import 'package:seriesapp/models/_models.dart';
import 'package:seriesapp/pages/_pages.dart';
import 'package:seriesapp/providers/following_provider.dart';
import 'package:seriesapp/utils/utils.dart';

class CastWidget extends StatelessWidget {
  final Cast cast;
  final bool showCrew;
  final bool isFromFav;
  const CastWidget({super.key, required this.cast, this.showCrew = false, this.isFromFav = false});

  @override
  Widget build(BuildContext context) {
    FollowingProvider followingProvider = Provider.of(context);
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onLongPress: () => Navigator.pushNamed(context, CastPage.routeName, arguments: cast.id),
        onTap: () => bottomCastDetail(context, cast),
        child: Container(
          width: 250,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color:
                  isFromFav || followingProvider.containsFavorite(cast.id) == null
                      ? Utils.naranjaSecundario
                      : Utils.verde,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: isFromFav ? 1 : 2,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(20),
                    child:
                        cast.profilePath!.isNotEmpty
                            ? CachedNetworkImage(
                              imageUrl: 'https://image.tmdb.org/t/p/original/${cast.profilePath}',
                              imageBuilder:
                                  (context, imageProvider) => Container(
                                    width: 100,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.fitHeight,
                                      ),
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
                            )
                            : Center(child: Icon(Icons.no_photography_rounded, size: 75)),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(cast.name),
                      Text(cast.character ?? ''),
                      RatingBarIndicator(
                        rating: cast.popularity / 2,
                        itemBuilder: (context, index) => Icon(Icons.star, color: Colors.amber),
                        itemCount: 5,
                        itemSize: 20,
                        direction: Axis.horizontal,
                      ),
                      if (showCrew) Text(cast.knownForDepartment, overflow: TextOverflow.ellipsis),
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
}
