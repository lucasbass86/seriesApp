import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:seriesapp/services/movie_service.dart';
import 'package:seriesapp/utils/enum.dart';
import 'package:seriesapp/utils/utils.dart';
import 'package:seriesapp/widgets/_widgets.dart';

class GenrePage extends StatelessWidget {
  const GenrePage({super.key});

  @override
  Widget build(BuildContext context) {
    MovieService movieService = Provider.of(context);
    return Padding(
      padding: const EdgeInsets.all(10),
      child:
          Utils.typeFilter == ETypeFilter.tv
              ? ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: movieService.tvGenres.length,
                itemBuilder:
                    (context, index) => ZoomIn(
                      delay: Duration(milliseconds: index * 33),
                      child: GenreWidget(genre: movieService.tvGenres[index]),
                    ),
                separatorBuilder: (context, index) => SizedBox(height: 10),
              )
              : ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: movieService.movieGenres.length,
                itemBuilder:
                    (context, index) => ZoomIn(
                      delay: Duration(milliseconds: index * 33),
                      child: GenreWidget(genre: movieService.movieGenres[index]),
                    ),
                separatorBuilder: (context, index) => SizedBox(height: 10),
              ),
    );
  }
}
