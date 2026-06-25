import 'package:flutter/material.dart';
import 'package:seriesapp/pages/_pages.dart';

class ImageWidget extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;
  final List<String> urls;
  final int index;
  final String title;
  const ImageWidget({
    super.key,
    required this.imageUrl,
    required this.height,
    required this.width,
    required this.urls,
    required this.index,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () => Navigator.pushNamed(context, ImagesPage.routeName, arguments: [urls, index, title]),
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(20),
        child: Container(
          constraints: BoxConstraints(maxHeight: height, maxWidth: width),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stackTrace) {
              return Text('Error al cargar la imagen');
            },
          ),
        ),
      ),
    );
  }
}
