import 'package:flutter/material.dart';
import 'package:seriesapp/utils/utils.dart';

class NoConnectionPage extends StatelessWidget {
  static const String routeName = 'NoConnectionPage';
  const NoConnectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset(Utils.logo),
        title: Text('Series App'),
        actionsPadding: const EdgeInsets.only(right: 10),
        backgroundColor: Utils.naranjaClarito,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.signal_wifi_connected_no_internet_4_rounded,
              size: 150,
              color: Utils.naranjaClarito,
            ),
            Text('No hay conexión', style: TextStyle(fontSize: 25, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
