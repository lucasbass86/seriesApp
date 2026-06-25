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
      elevation: 13,
      shadowColor: Utils.naranjaClarito,
      shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(20)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            height: 210,
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
                                  height: 210,
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
                        Text(
                          following.model.name,
                          style: TextStyle(fontSize: 17),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              if (following.model.mediaType == 'tv')
                                Column(
                                  children: [
                                    DropdownButton(
                                      underline: Container(),
                                      borderRadius: BorderRadius.circular(20),
                                      dropdownColor: Utils.naranjaSecundario,
                                      value: following.selectedSeason,
                                      isExpanded: true,
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
                                    if (following.selectedSeason != null)
                                      DropdownButton(
                                        underline: Container(),
                                        borderRadius: BorderRadius.circular(20),
                                        dropdownColor: Utils.naranjaSecundario,
                                        value: following.selectedChapter,
                                        isExpanded: true,
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
                                  ],
                                ),
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
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.lightBlue),
                              ),
                              child: Text('+ info', style: TextStyle(color: Colors.lightBlue)),
                            ),
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
