import 'package:flutter/material.dart';
import 'package:seriesapp/utils/utils.dart';

class ButtonWidget extends StatelessWidget {
  final bool isGood;
  final String text;
  final double width;
  final Function onTap;
  const ButtonWidget({
    super.key,
    this.isGood = true,
    required this.text,
    this.width = 150,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap.call(),
      child: Container(
        width: width,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isGood ? Utils.verde : Utils.rojo,
        ),
        child: Center(child: Text(text)),
      ),
    );
  }
}
