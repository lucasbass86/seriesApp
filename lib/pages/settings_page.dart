import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:seriesapp/dialogs/dialogs.dart';
import 'package:seriesapp/models/_models.dart';
import 'package:seriesapp/preferences/preferences.dart';
import 'package:seriesapp/providers/following_provider.dart';
import 'package:seriesapp/providers/historic_provider.dart';
import 'package:seriesapp/services/backup_service.dart';
import 'package:seriesapp/utils/utils.dart';

class SettingsPage extends StatefulWidget {
  static const String routeName = 'SettingsPage';
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late FollowingProvider followingProvider;
  TextEditingController emailController = TextEditingController(text: Preferences.email);
  @override
  Widget build(BuildContext context) {
    followingProvider = Provider.of(context);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchListTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(20)),
            value: Preferences.adulto,
            title: Text('Contenido adulto'),
            contentPadding: const EdgeInsets.all(0),
            onChanged: (value) {
              setState(() {
                Preferences.adulto = value;
              });
            },
          ),
          FutureBuilder(
            future: Utils.checkConnection(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                bool resp = snapshot.data as bool;
                if (resp) {
                  return _email(context);
                } else {
                  return _noConnection();
                }
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [_widgetSaveButton(), _widgetLoadButton(), const SizedBox(width: 30)],
          ),
          const Expanded(child: SizedBox(height: 1)),
          const _EraseHistoric(),
          const _AppInfo(),
        ],
      ),
    );
  }

  Widget _noConnection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Icon(Icons.wifi_off_rounded), Text('No hay conexión')],
    );
  }

  Widget _email(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Email para las copias'),
        SizedBox(height: 20),
        ZoomIn(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 65,
                  margin: const EdgeInsets.only(right: 20),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: TextFormField(
                    controller: emailController,
                    enabled: Preferences.email.isEmpty,
                    decoration: InputDecoration(filled: true),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
              ),
              if (Preferences.email.isEmpty)
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    if (emailController.text.isEmpty) {
                      _showSnackBar('Introduce el email');
                    } else {
                      if (Utils.isValidEmail(emailController.text)) {
                        _saveDataBackup(context);
                      } else {
                        _showSnackBar('Email inválido');
                      }
                    }
                  },
                  child: Icon(Icons.save),
                ),
              if (Preferences.email.isNotEmpty)
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => _removeEmail(context),
                  child: Icon(Icons.emergency_rounded),
                ),
            ],
          ),
        ),
        SizedBox(height: 40),
        if (Preferences.email.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _widgetUpload(context),
              _widgetDownload(context),
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => _deleteBackupData(context),
                child: Icon(Icons.delete),
              ),
            ],
          ),
        SizedBox(height: 40),
        Text(
          'Última copia: ${Preferences.backUp.isEmpty ? '--/--/----' : Utils.dateEnglishToSpanish(Preferences.backUp, showTime: true)}',
        ),
      ],
    );
  }

  Widget _widgetDownload(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _downloadData(context),
        child: FadeInRight(
          child: Ink(
            width: 140,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Utils.naranjaSecundario),
            ),
            child: Column(
              children: [Text('Cargar datos'), const SizedBox(height: 5), Icon(Icons.restore)],
            ),
          ),
        ),
      ),
    );
  }

  Widget _widgetUpload(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _uploadData(context),
        child: FadeInLeft(
          child: Ink(
            width: 140,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Utils.naranjaSecundario),
            ),
            child: Column(
              children: [Text('Subir datos'), const SizedBox(height: 5), Icon(Icons.backup_sharp)],
            ),
          ),
        ),
      ),
    );
  }

  Widget _widgetSaveButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _saveData(context),
        child: FadeInDown(
          child: Ink(
            width: 140,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Utils.naranjaSecundario),
            ),
            child: Column(
              children: [Text('Guardar'), const SizedBox(height: 5), Icon(Icons.save_alt_rounded)],
            ),
          ),
        ),
      ),
    );
  }

  Widget _widgetLoadButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _loadData(context),
        child: FadeInUp(
          child: Ink(
            width: 140,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Utils.naranjaSecundario),
            ),
            child: Column(
              children: [
                Text('Cargar'),
                const SizedBox(height: 5),
                Icon(Icons.restart_alt_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _setData(User user) async {
    followingProvider.following = user.following;
    followingProvider.favorites = user.favorites;

    await Utils.boxFollowing.deleteAll(Utils.boxFollowing.keys);
    await Utils.boxFavorites.deleteAll(Utils.boxFavorites.keys);

    for (FollowingModel p in user.following) {
      await Utils.boxFollowing.put(p.id, p.toJson());
    }
    for (FavoriteModel s in user.favorites) {
      await Utils.boxFavorites.put(s.id, s.toJson());
    }
    _showSnackBar('Datos cargados');
  }

  void _removeEmail(BuildContext context) async {
    final resp = await showMessage(context: context, message: '¿Quitar el email?', cancel: true);
    if (resp && context.mounted) {
      final unlock = await showSlideToUnlock(
        context,
        backColor: Utils.naranjaClarito,
        slideColor: Utils.naranjaPrincipal,
        textColor: Colors.black,
      );
      if (unlock) {
        Preferences.passBackUp = '';
        Preferences.email = '';
        Preferences.backUp = '';
        emailController.text = '';
        setState(() {});
      }
    }
  }

  Future<void> _saveDataBackup(BuildContext context) async {
    try {
      // Mostrar indicador de carga
      final dialogContext = context;
      showDialog(
        context: dialogContext,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final pass = await password(context);

      if (!context.mounted) return;

      final pass2 = await password(context, title: 'Repite password');

      // Cerrar el diálogo de carga
      if (context.mounted) {
        Navigator.of(dialogContext).pop();
      }

      // Validar el resultado de password
      if (!context.mounted || pass == null || pass.isEmpty || !pass[0]) return;

      if (pass[1] != pass2[1]) {
        _showSnackBar('Las contraseñas no coinciden.');
        return;
      }

      // Guardar preferencias y actualizar estado
      Preferences.email = emailController.text;
      Preferences.passBackUp = pass[1];
      FocusManager.instance.primaryFocus?.unfocus();
      setState(() {});

      _showSnackBar('Email guardado');
    } catch (e) {
      // Cerrar el diálogo de carga en caso de error
      if (context.mounted) Navigator.of(context).pop();
      if (context.mounted) {
        _showSnackBar('Error al guardar: $e');
      }
    }
  }

  Future<void> _deleteBackupData(BuildContext context) async {
    final confirmed = await showMessage(
      context: context,
      message: '¿Borrar todos los datos de la copia?',
      cancel: true,
    );

    if (!confirmed || !context.mounted) return;

    final unlocked = await showSlideToUnlock(
      context,
      backColor: Utils.naranjaClarito,
      slideColor: Utils.naranjaPrincipal,
      textColor: Colors.black,
    );

    if (!unlocked || !context.mounted) return;

    try {
      // Mostrar indicador de carga
      final dialogContext = context;
      showDialog(
        context: dialogContext,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      await BackupService.deleteBackUp(emailController.text);

      // Actualizar preferencias y estado
      Preferences.email = '';
      Preferences.backUp = '';
      emailController.text = '';
      setState(() {});

      if (context.mounted) {
        // Cerrar el diálogo de carga
        Navigator.of(dialogContext).pop();
        _showSnackBar('Datos borrados');
      }
    } catch (e) {
      if (context.mounted) {
        // Cerrar el diálogo de carga
        Navigator.of(context).pop();
        _showSnackBar('Error al borrar datos: $e');
      }
    }
  }

  Future<void> _uploadData(BuildContext context) async {
    final resp = await showSlideToUnlock(
      context,
      backColor: Utils.naranjaClarito,
      slideColor: Utils.naranjaPrincipal,
      textColor: Colors.black,
    );
    if (resp) {
      User user = User(
        email: Preferences.email,
        password: Preferences.passBackUp,
        following: followingProvider.following,
        favorites: followingProvider.favorites,
      );
      final dialogContext = context;
      if (dialogContext.mounted) {
        showDialog(
          context: dialogContext,
          barrierDismissible: false,
          builder: (context) => const Center(child: CircularProgressIndicator()),
        );
      }

      BackupService.addBackUp(user).then((onValue) {
        _showSnackBar('Copia subida');
        Preferences.backUp = DateTime.now().toString();
        setState(() {});
      });
      if (context.mounted) {
        Navigator.of(dialogContext).pop();
      }
    }
  }

  Future<void> _downloadData(BuildContext context) async {
    try {
      // Mostrar indicador de carga
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Center(child: CircularProgressIndicator()),
      );

      // Obtener datos del usuario
      final user = await BackupService.getBackUp(Preferences.email);
      if (context.mounted) {
        Navigator.pop(context); // Cerrar indicador de carga
      }
      if (user == null) {
        _showSnackBar('Email no encontrado');
        return;
      }
      // Validar contraseña
      if (context.mounted) {
        final passResult = await password(context);
        if (!passResult[0]) {
          _showSnackBar('Proceso omitido');
          return;
        }
        if (passResult[1] != Preferences.passBackUp) {
          _showSnackBar('La contraseña es incorrecta');
          return;
        }
      }

      // Confirmar acción
      if (context.mounted) {
        final shouldContinue = await showMessage(
          context: context,
          message: 'Si hay datos, estos se sustituirán. ¿Continuar?',
          cancel: true,
        );
        if (!shouldContinue) {
          _showSnackBar('Proceso omitido');
          return;
        }
      }
      if (context.mounted) {
        // Deslizar para desbloquear
        final isUnlocked = await showSlideToUnlock(
          context,
          backColor: Utils.naranjaClarito,
          slideColor: Utils.naranjaPrincipal,
          textColor: Colors.black,
        );
        if (isUnlocked) {
          _setData(user);
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context, false); // Cerrar indicador de carga en caso de error
      }
      _showSnackBar('Error: ${e.toString()}');
    }
  }

  Future<void> _saveData(BuildContext context) async {
    User user = User(
      email: Preferences.email,
      password: Preferences.passBackUp,
      following: followingProvider.following,
      favorites: followingProvider.favorites,
    );
    final contenido = json.encode(user.toJson());
    await Utils.guardarArchivoEnDescargas(
      'YoYa save ${Utils.dateEnglishToSpanish(DateTime.now().toString(), showTime: false)}.json',
      contenido,
    ).then((onValue) {
      if (onValue) {
        _showSnackBar('Archivo descargado');
      } else {
        _showSnackBar('Alfo ha fallado . . .');
      }
    });
  }

  Future<void> _loadData(BuildContext context) async {
    final path = await Utils.seleccionarArchivo();
    if (path.isNotEmpty && context.mounted) {
      final resp = await showMessage(context: context, message: '¿Restaurar archivo?');
      if (resp && context.mounted) {
        final unlock = await showSlideToUnlock(
          context,
          backColor: Utils.naranjaClarito,
          slideColor: Utils.naranjaPrincipal,
          textColor: Colors.black,
        );
        if (unlock) {
          final Map<String, dynamic> dataJson = json.decode(path);
          User user = User.fromJson(dataJson);
          _setData(user);
        } else {
          _showSnackBar('Proceso omitido');
        }
      } else {
        _showSnackBar('Algo ha fallado . . .');
      }
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(Utils.snackBar(message));
  }
}

class _AppInfo extends StatelessWidget {
  const _AppInfo();

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FutureBuilder(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                PackageInfo packageInfo = snapshot.data as PackageInfo;
                return GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      constraints: const BoxConstraints(maxHeight: 150),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
                      ),
                      builder: (context) {
                        return Container(
                          padding: const EdgeInsets.all(20),
                          width: double.infinity,
                          child: Column(
                            children: [
                              Text('Versión: ${packageInfo.version}'),
                              const SizedBox(height: 20),
                              Text('Actualizada el 10/05/2025'),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Text('Versión: ${packageInfo.version}'),
                );
              } else {
                return Text('Versión:');
              }
            },
          ),
          Text('Licencia: ${Preferences.license}'),
        ],
      ),
    );
  }
}

class _EraseHistoric extends StatelessWidget {
  const _EraseHistoric();

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      child: ListTile(
        title: Text('Borrar historial'),
        trailing: GestureDetector(
          onTap: () async {
            bool del = await showSlideToUnlock(
              context,
              backColor: Utils.naranjaClarito,
              slideColor: Utils.naranjaPrincipal,
              textColor: Colors.black,
            );
            if (del && context.mounted) {
              HistoricProvider historicProvider = Provider.of(context, listen: false);
              historicProvider.removeAll();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(Utils.snackBar('Historial borrado', isGood: false));
            }
          },
          child: Icon(Icons.delete, color: Utils.naranjaPrincipal),
        ),
        contentPadding: EdgeInsets.all(0),
      ),
    );
  }
}
