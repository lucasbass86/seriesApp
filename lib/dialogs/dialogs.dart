import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:seriesapp/models/_models.dart';
import 'package:seriesapp/widgets/_widgets.dart';

Future<dynamic> showMessage({
  required BuildContext context,
  required String message,
  String secondMessage = '',
  bool cancel = false,
}) {
  return showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return BounceInDown(
        child: AlertDialog(
          // backgroundColor: Utils.darkColorBackground,
          title: Text("Información"),
          content: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(message), if (secondMessage.isNotEmpty) Text(secondMessage)],
            ),
          ),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
          actions: [
            if (cancel)
              OutlinedButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Cancelar'),
              ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    },
  ).then((onValue) => onValue ?? false);
}

Future<bool> showSlideToUnlock(
  BuildContext context, {
  Color backColor = const Color.fromRGBO(224, 224, 224, 1),
  Color slideColor = Colors.blue,
  String text = 'Desliza para confirmar',
  Color textColor = Colors.white,
  IconData iconData = Icons.arrow_forward,
}) async {
  final unlocked = await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      double offset = 0.0;
      bool unlocked0 = false;
      return StatefulBuilder(
        builder: (context, setState) {
          final width = MediaQuery.of(context).size.width - 32;
          final maxOffset = width - 80;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: backColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Opacity(
                        opacity: 1.0 - (offset / maxOffset),
                        child: Text(text, style: TextStyle(color: textColor)),
                      ),
                    ),
                    Positioned(
                      left: offset,
                      child: GestureDetector(
                        onHorizontalDragUpdate: (details) {
                          setState(() {
                            offset += details.delta.dx;
                            if (offset < 0) offset = 0;
                            if (offset > maxOffset) offset = maxOffset;
                          });
                        },
                        onHorizontalDragEnd: (_) {
                          if (offset > maxOffset * 0.9) {
                            setState(() {
                              unlocked0 = true;
                              offset = maxOffset;
                            });
                            Navigator.of(context).pop(true);
                          } else {
                            setState(() {
                              offset = 0;
                            });
                          }
                        },
                        child: Container(
                          width: 80,
                          height: 60,
                          decoration: BoxDecoration(
                            color: unlocked0 ? Colors.green : slideColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          alignment: Alignment.center,
                          child:
                              unlocked0
                                  ? Icon(Icons.check_rounded, color: Colors.green[900])
                                  : Icon(iconData, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
  return unlocked == true;
}

Future<dynamic> password(BuildContext context, {String title = 'Introduce el password'}) {
  final TextEditingController edPassword = TextEditingController();
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) {
      return BounceInDown(
        child: AlertDialog(
          // backgroundColor: Utils.darkColorBackground,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
          title: Text(title),
          content: StatefulBuilder(
            builder: (context, setState) {
              return TextFormField(
                onChanged: (value) {},
                controller: edPassword,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password';
                  }
                  return null;
                },
                decoration: InputDecoration(hintText: 'Password'),
              );
            },
          ),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop([false]),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop([true, edPassword.text]);
              },
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    },
  );
}

Future<dynamic> showDialogInput(
  BuildContext scaffoldContext, {
  TextInputType? inputType,
  String subtitle = '',
  String label = '',
  int maxLength = 75,
}) {
  TextEditingController controller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  return showDialog(
    context: scaffoldContext,
    barrierDismissible: false,
    builder: (context) {
      return BounceInDown(
        child: AlertDialog(
          // backgroundColor: Utils.darkColorBackground,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Indica el $label'),
              if (subtitle.isNotEmpty)
                Column(
                  children: [
                    const SizedBox(height: 10),
                    Text(subtitle, style: TextStyle(fontSize: 20)),
                  ],
                ),
            ],
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      ZoomIn(
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Rellena el $label';
                            }
                            return null;
                          },
                          controller: controller,
                          maxLength: maxLength,
                          decoration: InputDecoration(labelText: label, counterText: ''),
                          keyboardType: inputType ?? TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
          ),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop([false]),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.of(context).pop([true, controller.text]);
                } else {
                  return;
                }
              },
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    },
  );
}

Future<dynamic> showNewCredits(BuildContext context, List<FavoriteModel> favorites) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Hay material nuevo de'),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
        backgroundColor: Colors.white,
        content: ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(20),
          child: SizedBox(
            height: 400,
            width: double.maxFinite,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children:
                    favorites.asMap().entries.map((entry) {
                      Person person = entry.value.person;
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
                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: CastWidget(cast: cast),
                      );
                    }).toList(),
              ),
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Aceptar'),
          ),
        ],
      );
    },
  );
}
