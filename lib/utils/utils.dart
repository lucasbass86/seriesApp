import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:seriesapp/utils/enum.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;

class Utils {
  static const Color naranjaPrincipal = Color(0xfff39633);
  static const Color naranjaSecundario = Color(0xfff9c34e);
  static const Color naranjaClarito = Color.fromARGB(255, 248, 224, 172);
  static const Color rojo = Color(0xffFF5E5E);
  static const Color verde = Color(0xffA4C400);
  static const String logo = 'assets/series_icon.png';

  static ETypeFilter typeFilter = ETypeFilter.tv;
  static EOrderTV orderTV = EOrderTV.voteCountDesc;
  static EOrderMovie orderMovie = EOrderMovie.voteCountDesc;

  static Directory path = Directory('');
  static const String boxFollowingName = 'SeriesAppFollowing';
  static const String boxFavoritesName = 'SeriesAppFavorites';
  static const String boxHistoricSearch = 'SeriesAppHistoricSearch';
  static final Box boxFollowing = Hive.box(boxFollowingName);
  static final Box boxFavorites = Hive.box(boxFavoritesName);
  static final Box boxHistoric = Hive.box(boxHistoricSearch);

  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  static Future<bool> checkConnection() async {
    try {
      final result = await InternetAddress.lookup('www.google.es');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  static String dateEnglishToSpanish(String date, {bool showTime = false}) {
    if (date.isEmpty) return '';
    String year = date.substring(0, 4);
    String month = date.substring(5, 7);
    String day = date.substring(8, 10);
    if (!showTime) {
      return "$day-$month-$year";
    } else {
      String hour = date.substring(11, 13);
      String minute = date.substring(14, 16);
      return "$day-$month-$year $hour:$minute";
    }
  }

  static int calcularEdad(DateTime fechaNacimiento, {DateTime? otherDate}) {
    final fechaActual = otherDate ?? DateTime.now();
    int edad = fechaActual.year - fechaNacimiento.year;
    if (fechaActual.month < fechaNacimiento.month ||
        (fechaActual.month == fechaNacimiento.month && fechaActual.day < fechaNacimiento.day)) {
      edad--;
    }

    return edad;
  }

  static SnackBar snackBar(String message, {bool isGood = true}) {
    return SnackBar(
      backgroundColor: isGood ? Utils.verde : Utils.rojo,
      shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(20)),
      behavior: SnackBarBehavior.floating,
      content: Text(message),
    );
  }

  static Future<void> solicitarPermisoStorage() async {
    var status = await Permission.storage.status;

    if (status.isGranted) {
      // print("Permiso ya concedido");
      return;
    }

    if (status.isDenied) {
      // Primer intento o denegado sin "No volver a preguntar"
      var nuevoStatus = await Permission.storage.request();
      if (nuevoStatus.isGranted) {
        // print("Permiso concedido tras solicitarlo");
      } else if (nuevoStatus.isPermanentlyDenied) {
        // Lo denegó y marcó “No volver a preguntar”
        // print("Permiso denegado permanentemente. Redirigiendo a configuración...");
        openAppSettings();
      } else {
        // print("Permiso denegado");
      }
    } else if (status.isPermanentlyDenied) {
      // print("Permiso ya estaba denegado permanentemente. Redirigiendo...");
      openAppSettings();
    }
  }

  static Future<bool> guardarArchivoEnDescargas(String nombreArchivo, String contenido) async {
    // Pide permisos
    solicitarPermisoStorage();

    // Obtiene la ruta de Descargas (solo Android)
    final Directory downloadsDir = Directory('/storage/emulated/0/Download');

    if (downloadsDir.existsSync()) {
      final archivo = File(p.join(downloadsDir.path, nombreArchivo));
      await archivo.writeAsString(contenido);
      notificarSistemaArchivo(archivo.path);
      return true;
    } else {
      return false;
    }
  }

  static Future<void> notificarSistemaArchivo(String pathArchivo) async {
    const platform = MethodChannel('com.lucas.seriesapp');
    try {
      await platform.invokeMethod('scanFile', {'path': pathArchivo});
    } catch (e) {
      // print("Error al notificar sistema: $e");
    }
  }

  static Future<String> seleccionarArchivo() async {
    FilePickerResult? filePicker = await FilePicker.platform.pickFiles(
      withData: false,
      type: FileType.any,
      allowMultiple: false,
    );
    if (filePicker != null && filePicker.files.single.path != null) {
      File file = File(filePicker.files.single.path!);
      String contenido = await file.readAsString();
      return contenido;
    } else {
      return '';
    }
  }

  static String timeOfDayToString(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
