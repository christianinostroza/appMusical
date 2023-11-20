// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

class XylophoneKey extends StatelessWidget {
  final int keyNumber;
  final String soundFileName;
  final Color keyColor;
  final Animation<double> animation;
  final void Function(int, String) onTapDown;
  final void Function(int) onTapUp;

  const XylophoneKey({
    required this.keyNumber,
    required this.soundFileName,
    required this.keyColor,
    required this.animation,
    required this.onTapDown,
    required this.onTapUp,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => onTapDown(keyNumber, soundFileName),
      onTapUp: (_) => onTapUp(keyNumber),
      child: Transform.scale(
        scale: animation.value,
        child: Container(
          width: 50.0,
          height: 150.0,
          margin: const EdgeInsets.all(5.0),
          color: keyColor,
        ),
      ),
    );
  }
}
