import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:seriesapp/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:convert';

List<Versiones> versionesFromJson(String str) =>
    List<Versiones>.from(json.decode(str).map((x) => Versiones.fromJson(x)));

class Versiones {
  String appname;
  String appversion;

  @override
  String toString() {
    return '$appname:$appversion';
  }

  Versiones({required this.appname, required this.appversion});

  factory Versiones.fromJson(Map<String, dynamic> json) =>
      Versiones(appname: json["APPNAME"], appversion: json["APPVERSION"]);
}

List<CResultado> cResultadoFromJson(String str) =>
    List<CResultado>.from(json.decode(str).map((x) => CResultado.fromJson(x)));

class CResultado {
  String resultado;

  @override
  String toString() {
    return resultado;
  }

  CResultado({required this.resultado});

  factory CResultado.fromJson(Map<String, dynamic> json) =>
      CResultado(resultado: json["RESULTADO"].toString());
}

class UpdateService {
  static final String _urlVersiones =
      'http://www.escayolasdelucas.com/apps/versiones/getVersiones.php';
  final String _urlUsuarios = 'http://www.escayolasdelucas.com/apps/versiones/set_user_app.php';
  final String _urlUserLock = 'http://www.escayolasdelucas.com/apps/versiones/set_user_lock.php';
  static List<Versiones> versiones = [];
  List<CResultado> resultado = [];
  final String app = 'SeriesApp';

  static Future<List<Versiones>> getVersiones() async {
    final response = await http.get(Uri.parse(_urlVersiones));
    versiones = versionesFromJson(response.body);
    return versiones;
  }

  Future<List<CResultado>> setUser(String id, String info) async {
    final response = await http.post(
      Uri.parse(_urlUsuarios),
      body: {'app': app, 'id': id, 'info': info},
    );
    resultado = cResultadoFromJson(response.body);
    return resultado;
  }

  Future<List<CResultado>> getUserLock(String id, String info) async {
    final params = {'app': app, 'id': id};
    final uri = Uri.parse(_urlUserLock).replace(queryParameters: params);
    final response = await http.get(uri);

    resultado = cResultadoFromJson(response.body);
    return resultado;
  }
}

class UpdatePage extends StatelessWidget {
  static const String routeName = 'UpdatePage';
  const UpdatePage({super.key});
  final String urlUpdatePath =
      'https://drive.google.com/file/d/1d9PCBpOI1H6t8V9kne6r0oY_5nxzx-JR/view?usp=sharing';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.only(top: 30, right: 30),
                child: GestureDetector(
                  onTap: () => SystemNavigator.pop(),
                  child: Icon(Icons.power_settings_new_rounded),
                ),
              ),
            ),
            Expanded(child: Icon(Icons.download_rounded, size: 150)),
            Text(
              'Existe una versión más reciente',
              /*style: Utils.bigTitleStyle,*/ textAlign: TextAlign.center,
            ),
            GestureDetector(
              onTap: () async {
                !await launchUrl(Uri.parse(urlUpdatePath), mode: LaunchMode.externalApplication);
              },
              child: Container(
                height: 50,
                margin: const EdgeInsets.only(left: 40, right: 40, bottom: 40, top: 40),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Utils.naranjaClarito,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Center(
                  child: Text(
                    'Actualizar' /*, style: Utils.normalStyle20.copyWith(color: Utils.darkColorSecond)*/,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
