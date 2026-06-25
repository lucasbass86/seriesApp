import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:seriesapp/models/_models.dart';
import 'package:seriesapp/pages/_pages.dart';

Future<dynamic> bottomCastDetail(BuildContext context, Cast cast) {
  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return InkWell(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        onTap: () => Navigator.pushNamed(context, CastPage.routeName, arguments: cast.id),
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(20),
                child:
                    cast.profilePath!.isNotEmpty
                        ? CachedNetworkImage(
                          imageUrl: 'https://image.tmdb.org/t/p/original/${cast.profilePath}',
                          imageBuilder:
                              (context, imageProvider) => Container(
                                width: 200,
                                height: 300,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ),
                          placeholder:
                              (context, url) => Container(
                                width: 200,
                                padding: const EdgeInsets.all(10),
                                child: Center(child: CircularProgressIndicator()),
                              ),
                          errorWidget:
                              (context, url, error) => Container(
                                width: 200,
                                padding: const EdgeInsets.all(10),
                                child: Icon(Icons.error),
                              ),
                        )
                        : Center(child: Icon(Icons.no_photography_rounded, size: 75)),
              ),
              const SizedBox(height: 5),
              SelectableText(cast.name, style: TextStyle(fontSize: 20)),
              const SizedBox(height: 5),
              Text(cast.character ?? cast.knownForDepartment, style: TextStyle(fontSize: 20)),
              const Expanded(child: SizedBox(height: 1)),
              Align(
                alignment: Alignment.bottomRight,
                child: Text('+ info', style: TextStyle(color: Colors.lightBlue)),
              ),
            ],
          ),
        ),
      );
    },
  );
}
