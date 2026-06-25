import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:seriesapp/models/_models.dart';
import 'package:seriesapp/providers/following_provider.dart';
import 'package:seriesapp/utils/utils.dart';
import 'package:seriesapp/widgets/_widgets.dart';

class FavoritePage extends StatelessWidget {
  static final String routeName = 'FavoritePage';
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    FollowingProvider followingProvider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(onTap: () => Navigator.pop(context), child: Text('Favoritos')),
        backgroundColor: Utils.naranjaClarito,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child:
            followingProvider.favorites.isNotEmpty
                ? ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(20),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: followingProvider.favorites.length,
                    itemBuilder: (context, index) {
                      Person person = followingProvider.favorites[index].person;
                      Cast cast = Cast(
                        adult: person.adult,
                        gender: person.gender,
                        id: person.id,
                        name: person.name,
                        originalName: '',
                        popularity: person.popularity,
                        profilePath: person.profilePath,
                        creditId: '',
                        knownForDepartment: person.knownForDepartment,
                      );
                      return FadeInLeft(
                        delay: Duration(milliseconds: index * 77),
                        child: CastWidget(cast: cast, isFromFav: true),
                      );
                    },
                    separatorBuilder:
                        (BuildContext context, int index) => const SizedBox(height: 10),
                  ),
                )
                : SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite, size: 200, color: Utils.naranjaClarito),
                      Text(
                        'No hay favoritos guardados',
                        style: TextStyle(fontSize: 25, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
