// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'xylophone_key.dart';

class XylophoneApp extends StatefulWidget {
  const XylophoneApp({Key? key});

  @override
  _XylophoneAppState createState() => _XylophoneAppState();
}

class _XylophoneAppState extends State<XylophoneApp>
    with TickerProviderStateMixin {
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _animations;
  final AudioPlayer _audioPlayer = AudioPlayer();

  final List<Color> _keyColors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.teal,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.pink,
    Colors.brown,
    Colors.grey,
    Colors.black,
  ];

  @override
  void initState() {
    super.initState();

    _animationControllers = List.generate(
      12,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1500),
      ),
    );

    for (var i = 0; i < _animationControllers.length; i++) {
      var controller = _animationControllers[i];
      controller.addListener(() {
        setState(() {});
      });

      controller.addStatusListener((status) {
        if (status == AnimationStatus.reverse) {
          controller.reset();
        }
      });

      controller.reverse();
    }

    _animations = _animationControllers
        .map((controller) => Tween(begin: 1.0, end: 1.8).animate(controller))
        .toList();

    for (var controller in _animationControllers) {
      controller.addListener(() {
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _playSound(String soundFileName) {
    _audioPlayer.play(DeviceFileSource('assets/$soundFileName'));
  }

  void _handleTapDown(int keyNumber, String soundFileName) {
    _animationControllers[keyNumber - 1].forward();
    _playSound(soundFileName);
  }

  void _handleTapUp(int keyNumber) {
    _animationControllers[keyNumber - 1].reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xylophone Musical'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 1; i <= 12; i++)
              XylophoneKey(
                keyNumber: i,
                soundFileName: 'note$i.mp3',
                keyColor: _keyColors[i - 1],
                animation: _animations[i - 1],
                onTapDown: _handleTapDown,
                onTapUp: _handleTapUp,
              ),
          ],
        ),
      ),
    );
  }
}
