import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:seriesapp/dialogs/dialogs.dart';
import 'package:seriesapp/models/_models.dart';
import 'package:seriesapp/pages/_pages.dart';
import 'package:seriesapp/preferences/preferences.dart';
import 'package:seriesapp/providers/following_provider.dart';
import 'package:seriesapp/services/license_service.dart';
import 'package:seriesapp/services/movie_service.dart';
import 'package:seriesapp/services/update_service.dart';
import 'package:seriesapp/utils/enum.dart';
import 'package:seriesapp/utils/utils.dart';

class HomePage extends StatefulWidget {
  static const String routeName = 'HomePage';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _hasRun = false;
  static const List<Widget> _widgetOptions = <Widget>[
    FollowingPage(),
    GenrePage(),
    TopPage(),
    SearchPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      Preferences.tabIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    if (!_hasRun) {
      _hasRun = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(seconds: 1), () async {
          if (context.mounted) {
            await _checkLicense(context);
            await _checkUpdates(context);
          }
        });
      });
    }
  }

  Future<void> _checkNewCredits(BuildContext context) async {
    FollowingProvider followingProvider = Provider.of(context, listen: false);
    List<FavoriteModel> news = await followingProvider.newCredits(context);
    // if (news.isNotEmpty && context.mounted) {
    //   ScaffoldMessenger.of(context).showSnackBar(Utils.snackBar('Hay material nuevo!!!'));
    // }
    if (news.isNotEmpty && context.mounted) {
      showNewCredits(context, news);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          Preferences.tabIndex != 3
              ? AppBar(
                leading: Image.asset(Utils.logo),
                title: Text('Series App'),
                actions: [_filter()],
                actionsPadding: const EdgeInsets.only(right: 10),
                backgroundColor: Utils.naranjaClarito,
              )
              : null,
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.theaters_outlined), label: 'Guardados'),
          BottomNavigationBarItem(icon: Icon(Icons.theater_comedy_rounded), label: 'Generos'),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events_outlined), label: 'Top'),
          BottomNavigationBarItem(icon: Icon(Icons.search_sharp), label: 'Buscar'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        currentIndex: Preferences.tabIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
      body: Center(child: _widgetOptions.elementAt(Preferences.tabIndex)),
    );
  }

  Widget _filter() {
    if (Preferences.tabIndex == 0) {
      return GestureDetector(
        onTap: () => Navigator.pushNamed(context, FavoritePage.routeName),
        child: Icon(Icons.favorite, color: Utils.naranjaPrincipal),
      );
    }
    if (Preferences.tabIndex == 1) {
      return DropdownButton<ETypeFilter>(
        underline: Container(),
        borderRadius: BorderRadius.circular(20),
        dropdownColor: Utils.naranjaSecundario,
        value: Preferences.typeIndex == 0 ? ETypeFilter.tv : ETypeFilter.movie,
        items:
            ETypeFilter.values
                .map((ty) => DropdownMenuItem<ETypeFilter>(value: ty, child: Text(ty.displayName)))
                .toList(),
        onChanged: (value) {
          setState(() {
            Utils.typeFilter = value!;
            Preferences.typeIndex = value == ETypeFilter.tv ? 0 : 1;
            Provider.of<MovieService>(context, listen: false).updateListeners();
          });
        },
      );
    } else {
      return Container();
    }
  }

  Future<void> _checkBackUp(BuildContext context) async {
    if (Preferences.backUp.isNotEmpty &&
        (Utils.boxFollowing.values.isNotEmpty || Utils.boxFavorites.isNotEmpty)) {
      if (DateTime.now().difference(DateTime.parse(Preferences.backUp)).inDays >= 15) {
        final resp = await showMessage(
          context: context,
          message: 'Llevas ciertos días sin hacer copia de seguridad. ¿Hacer copia?',
          cancel: true,
        );
        if (resp) {
          Preferences.tabIndex = 4;
          setState(() {});
        }
      }
    }
  }

  Future<void> _checkUpdates(BuildContext context) async {
    late PackageInfo packageInfo;
    bool hasUpdate = false;
    final hasConnected = await Utils.checkConnection();
    if (hasConnected) {
      PackageInfo.fromPlatform().then((value) async {
        packageInfo = value;
        final List<Versiones> rest = await UpdateService.getVersiones();
        if (rest.isNotEmpty) {
          if (rest
                  .firstWhere((v) => v.appname == 'seriesapp')
                  .appversion
                  .compareTo(packageInfo.version) >
              0) {
            hasUpdate = true;
            if (context.mounted) {
              Navigator.pushNamed(context, UpdatePage.routeName);
            }
          }
          if (!hasUpdate && context.mounted) {
            await _checkBackUp(context);
            await _checkNewCredits(context);
          }
        }
      });
    }
  }

  Future<void> _checkLicense(BuildContext context) async {
    final cnx = await Utils.checkConnection();
    if (cnx && Preferences.license.isEmpty) {
      if (context.mounted) {
        final em = await showDialogInput(
          context,
          subtitle: 'Se envía un código de verificación para registrarse.',
          label: 'Email',
          inputType: TextInputType.emailAddress,
        );
        if (em[0]) {
          final GetLicenseCodeResponse r = await LicenseService.obtainLicense(em[1]);
          if (r.status == LicenseService.success && context.mounted) {
            final code = await showDialogInput(
              context,
              label: 'Código',
              subtitle: 'Introduce el código de verificación',
              maxLength: 13,
            );
            if (code[0]) {
              final GetLicenseCodeResponse r2 = await LicenseService.setLicenseCode(code[1], em[1]);
              if (r2.status == LicenseService.success && context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(Utils.snackBar('Registrado correctamente'));
                Preferences.license = code[1];
                Preferences.email = em[1];
              }
            } else {
              SystemNavigator.pop();
            }
          }
        } else {
          SystemNavigator.pop();
        }
      }
    } else if (cnx && Preferences.license.isNotEmpty) {
      final GetLicenseCodeResponse r = await LicenseService.checkLicenseCode(Preferences.license);
      if (r.status == LicenseService.success) {
        MapData licenseData = r.data as MapData;
        if (licenseData.license != null) {
          if (licenseData.license!.locked == 1) {
            if (context.mounted) {
              await showMessage(
                context: context,
                message: 'Esta licencia está bloqueada. Contacta con ${LicenseService.emailDev}',
              ).then((_) {
                SystemNavigator.pop();
              });
            }
          }
          if (licenseData.license!.message.isNotEmpty) {
            if (context.mounted) {
              await showMessage(context: context, message: licenseData.license!.message);
            }
          }
        }
      } else {
        if (context.mounted) {
          await showMessage(
            context: context,
            message:
                'Ha habido un problema con la licencia. Contacta con ${LicenseService.emailDev}',
          ).then((_) {
            SystemNavigator.pop();
          });
        }
      }
    } else if (!cnx && Preferences.license.isEmpty) {
      if (context.mounted) {
        await showMessage(
          context: context,
          message: 'Necesita tener conexión para verificar la licencia',
        ).then((_) {
          SystemNavigator.pop();
        });
      }
    }
  }
}
