// ignore_for_file: prefer_is_empty

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:seriesapp/preferences/preferences.dart';
import 'package:seriesapp/utils/utils.dart';

class ImagesPage extends StatefulWidget {
  static const String routeName = 'ImagesPage';
  const ImagesPage({super.key});

  @override
  State<ImagesPage> createState() => _ImagesPageState();
}

class _ImagesPageState extends State<ImagesPage> {
  late final PageController pageController;
  TransformationController transformationController = TransformationController();
  late int indexImg;
  late List<String> urls;
  late Image image;
  bool _isLoading = true;
  List<Image> images = [];
  String title = 'Imágenes';
  @override
  Widget build(BuildContext context) {
    final dynamic arguments = ModalRoute.of(context)!.settings.arguments as dynamic;
    if (_isLoading) {
      _isLoading = false;
      urls = arguments[0];
      indexImg = arguments[1];
      title = arguments[2];
      pageController = PageController(initialPage: indexImg);
      images =
          urls
              .map(
                (i) => Image.network(
                  'https://image.tmdb.org/t/p/original/$i',
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              )
              .toList();
    }
    image = images[indexImg];
    return Scaffold(
      backgroundColor:
          Preferences.imagesInDark ? Colors.black : Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Utils.naranjaClarito,
        title: GestureDetector(onTap: () => Navigator.pop(context), child: Text(title)),
        actionsPadding: EdgeInsets.only(right: 10),
        actions: [
          GestureDetector(
            onTap: () => setState(() => Preferences.imagesInDark = !Preferences.imagesInDark),
            child: Icon(Preferences.imagesInDark ? Icons.sunny : Icons.nightlight_round),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: InteractiveViewer(
                  minScale: 0.2,
                  maxScale: 20,
                  transformationController: transformationController,
                  child: PageView.builder(
                    scrollDirection: Axis.horizontal,
                    controller: pageController,
                    itemCount: urls.length,
                    itemBuilder: (context, index) => images[index],
                    onPageChanged: (value) => transformationController.value = Matrix4.identity(),
                  ),
                ),
              ),
            ),
            if (urls.length > 1)
              SizedBox(
                height: 50,
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: urls.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          transformationController.value = Matrix4.identity();
                          pageController.jumpToPage(index);
                        });
                      },
                      child: FadeInUp(
                        delay: Duration(milliseconds: index * 20),
                        child: images[index],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(width: 10),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
