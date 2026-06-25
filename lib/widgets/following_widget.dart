import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:seriesapp/models/_models.dart';
import 'package:seriesapp/pages/_pages.dart';
import 'package:seriesapp/providers/following_provider.dart';
import 'package:seriesapp/utils/utils.dart';

class FollowingWidget extends StatelessWidget {
  final FollowingModel following;
  const FollowingWidget({super.key, required this.following});

  @override
  Widget build(BuildContext context) {
    FollowingProvider followingProvider = Provider.of(context, listen: false);
    TimeOfDay visualizado = TimeOfDay(hour: following.hour!, minute: following.minute!);
    return Card(
      elevation: 17,
      shadowColor: Utils.naranjaClarito,
      shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(20)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            height: 190,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(20),
                  child:
                      following.model.backdropPath.isNotEmpty
                          ? CachedNetworkImage(
                            imageUrl:
                                'https://image.tmdb.org/t/p/original/${following.model.posterPath}',
                            imageBuilder:
                                (context, imageProvider) => Container(
                                  width: 130,
                                  height: 190,
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(following.model.name, style: TextStyle(fontSize: 17)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (following.model.mediaType == 'tv')
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: DropdownButton(
                                        underline: Container(),
                                        borderRadius: BorderRadius.circular(20),
                                        dropdownColor: Utils.naranjaSecundario,
                                        value: following.selectedSeason,
                                        items:
                                            following.seasons!
                                                .map(
                                                  (s) => DropdownMenuItem(
                                                    value: s,
                                                    child: Text(
                                                      s.name,
                                                      style: TextStyle(fontSize: 13),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                        onChanged: (value) {
                                          followingProvider.updateFollowing(
                                            following,
                                            selectedSeason: value,
                                          );
                                        },
                                      ),
                                    ),
                                    if (following.selectedSeason != null)
                                      Flexible(
                                        flex: 1,
                                        child: DropdownButton(
                                          underline: Container(),
                                          borderRadius: BorderRadius.circular(20),
                                          dropdownColor: Utils.naranjaSecundario,
                                          value: following.selectedChapter,
                                          items: List.generate(
                                            following.selectedSeason!.episodeCount,
                                            (index) => DropdownMenuItem(
                                              value: index + 1,
                                              child: Text(
                                                'Capítulo ${index + 1}',
                                                style: TextStyle(fontSize: 13),
                                              ),
                                            ),
                                          ),
                                          onChanged: (value) {
                                            followingProvider.updateFollowing(
                                              following,
                                              selectedChapter: value,
                                            );
                                          },
                                        ),
                                      ),
                                  ],
                                ),
                              // const SizedBox(height: 10),
                              Row(
                                spacing: 20,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Visualizado:'),
                                  GestureDetector(
                                    onTap: () async {
                                      final resp = await showTimePicker(
                                        context: context,
                                        cancelText: 'Cancelar',
                                        confirmText: 'Aceptar',
                                        switchToInputEntryModeIcon: null,
                                        switchToTimerEntryModeIcon: null,
                                        hourLabelText: 'Hora',
                                        minuteLabelText: 'Minuto',
                                        barrierColor: Utils.naranjaClarito.withAlpha(100),
                                        helpText: 'Tiempo de visionado',
                                        initialEntryMode: TimePickerEntryMode.dialOnly,
                                        initialTime: TimeOfDay(
                                          hour: visualizado.hour,
                                          minute: visualizado.minute,
                                        ),
                                      );
                                      if (resp != null) {
                                        followingProvider.updateFollowing(
                                          following,
                                          hour: resp.hour,
                                          minute: resp.minute,
                                        );
                                      }
                                    },
                                    child: Text(
                                      Utils.timeOfDayToString(visualizado),
                                      style: TextStyle(fontSize: 30, color: Utils.naranjaPrincipal),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: GestureDetector(
                            onTap: () {
                              if (following.model.mediaType == 'tv') {
                                Navigator.pushNamed(
                                  context,
                                  TVDetailPage.routeName,
                                  arguments: following.model,
                                );
                              } else {
                                Navigator.pushNamed(
                                  context,
                                  MovieDetailPage.routeName,
                                  arguments: following.model,
                                );
                              }
                            },
                            child: Text('+ info', style: TextStyle(color: Colors.lightBlue)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
