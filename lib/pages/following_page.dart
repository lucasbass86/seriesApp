import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:seriesapp/providers/following_provider.dart';
import 'package:seriesapp/utils/utils.dart';
import 'package:seriesapp/widgets/_widgets.dart';

class FollowingPage extends StatefulWidget {
  const FollowingPage({super.key});

  @override
  State<FollowingPage> createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  @override
  Widget build(BuildContext context) {
    FollowingProvider followingProvider = Provider.of(context);
    return followingProvider.following.isNotEmpty
        ? ListView.separated(
          padding: const EdgeInsets.all(10),
          physics: const BouncingScrollPhysics(),
          itemCount: followingProvider.following.length,
          itemBuilder:
              (context, index) => FadeInLeft(
                delay: Duration(milliseconds: index * 77),
                child: FollowingWidget(following: followingProvider.following[index]),
              ),
          separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 20),
        )
        : SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.theaters_outlined, size: 200, color: Utils.naranjaClarito),
              Text(
                'No hay favoritos guardados',
                style: TextStyle(fontSize: 25, color: Colors.black54),
              ),
            ],
          ),
        );
  }
}
