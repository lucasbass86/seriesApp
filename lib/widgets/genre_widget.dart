import 'package:flutter/material.dart';
import 'package:seriesapp/models/_models.dart';
import 'package:seriesapp/pages/_pages.dart';
import 'package:seriesapp/utils/utils.dart';

class GenreWidget extends StatelessWidget {
  final TvGenre genre;
  const GenreWidget({super.key, required this.genre});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap:
          () => Navigator.pushNamed(
            context,
            GenreDetailPage.routeName,
            arguments: genre,
          ),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Utils.naranjaSecundario),
        ),
        child: Text(genre.name),
      ),
    );
  }
}
