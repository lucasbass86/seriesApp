import 'package:flutter/material.dart';
import 'package:seriesapp/utils/utils.dart';

ThemeData themeData = ThemeData.light().copyWith(
  splashColor: Utils.naranjaPrincipal,
  highlightColor: Utils.naranjaClarito,
  progressIndicatorTheme: ProgressIndicatorThemeData(color: Utils.naranjaPrincipal),
  appBarTheme: AppBarTheme(iconTheme: IconThemeData(color: Utils.naranjaPrincipal)),
  iconTheme: IconThemeData(color: Utils.naranjaPrincipal),
  dividerColor: Utils.naranjaClarito,
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Utils.naranjaPrincipal,
    selectionColor: Utils.naranjaSecundario,
    selectionHandleColor: Utils.naranjaPrincipal,
  ),
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: TextStyle(color: Utils.naranjaPrincipal),
    labelStyle: TextStyle(color: Utils.naranjaPrincipal),
    suffixIconColor: Utils.naranjaPrincipal,
    prefixIconColor: Utils.naranjaPrincipal,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Utils.naranjaPrincipal),
      borderRadius: BorderRadius.circular(20),
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Utils.naranjaPrincipal),
      borderRadius: BorderRadius.circular(20),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Utils.naranjaPrincipal),
      borderRadius: BorderRadius.circular(20),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Utils.naranjaPrincipal),
      borderRadius: BorderRadius.circular(20),
    ),
  ),
  //CANCELAR
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return Utils.naranjaPrincipal;
        } else {
          return Utils.naranjaClarito;
        }
      }),
      backgroundColor: WidgetStateProperty.resolveWith((states) => Utils.naranjaPrincipal),
      overlayColor: WidgetStateProperty.resolveWith((states) => Utils.naranjaClarito),
    ),
  ),
  //ACEPTAR
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      overlayColor: WidgetStateProperty.resolveWith((states) => Utils.naranjaPrincipal),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return Utils.naranjaClarito;
        } else {
          return Utils.naranjaPrincipal;
        }
      }),
      backgroundColor: WidgetStateProperty.resolveWith((states) => Utils.naranjaClarito),
    ),
  ),
  switchTheme: SwitchThemeData(
    trackColor: WidgetStateColor.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Utils.naranjaPrincipal;
      } else {
        return Utils.naranjaClarito;
      }
    }),
    thumbColor: WidgetStateColor.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Utils.naranjaSecundario;
      } else {
        return Colors.grey;
      }
    }),
    trackOutlineColor: WidgetStateColor.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Utils.naranjaSecundario;
      } else {
        return Utils.naranjaSecundario;
      }
    }),
  ),
  timePickerTheme: TimePickerThemeData(
    cancelButtonStyle: ButtonStyle(foregroundColor: WidgetStatePropertyAll(Utils.naranjaPrincipal)),
    confirmButtonStyle: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(Utils.naranjaPrincipal),
    ),
    dialBackgroundColor: Utils.naranjaClarito,
    dialHandColor: Utils.naranjaPrincipal,
    hourMinuteColor: Utils.naranjaClarito,
    hourMinuteTextColor: Utils.naranjaPrincipal,
  ),
);
