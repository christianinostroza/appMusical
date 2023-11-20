// ignore_for_file: library_private_types_in_public_api, unused_local_variable

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: XylophoneApp(),
    );
  }
}

class XylophoneApp extends StatefulWidget {
  const XylophoneApp({super.key});

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
        duration: const Duration(milliseconds: 300),
      ),
    );

    for (var i = 0; i < _animationControllers.length; i++) {
      var controller = _animationControllers[i];
      controller.addListener(() {
        setState(() {});
      });

      Color color = _keyColors[i];

      controller.addStatusListener((status) {
        if (status == AnimationStatus.reverse) {
          controller.reset();
        }
      });

      controller.reverse();
    }
    _animations = _animationControllers
        .map((controller) => Tween(begin: 1.0, end: 0.8).animate(controller))
        .toList();

    for (var controller in _animationControllers) {
      controller.addListener(() {
        setState(() {});
      });
    }
  }

  void _playSound(String soundFileName) {
    _audioPlayer.play(DeviceFileSource('assets/$soundFileName'),
        mode: PlayerMode.lowLatency);
  }

//  Future<void> _playSound(String soundFileName) async {
//   // await _audioPlayer.play(DeviceFileSource('assets/$soundFileName'));

//   await _audioPlayer.setSource(AssetSource(soundFileName));
// }

  void _handleTapDown(int keyNumber, TapDownDetails details,
      String soundFileName, Color keyColor) {
    _animationControllers[keyNumber - 1].forward();
    _playSound(soundFileName);
    _showNote(keyNumber, keyColor);
  }

  void _handleTapUp(int keyNumber, TapUpDetails details) {
    _animationControllers[keyNumber - 1].reverse();
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('XyloFono Musical'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 1; i <= 9; i++)
              _buildKey(i, 'note$i.mp3', _keyColors[i - 1], _animations[i - 1]),
          ],
        ),
      ),
    );
  }

  Widget _buildKey(int keyNumber, String soundFileName, Color keyColor,
      Animation<double> animation) {
    return GestureDetector(
      onTapDown: (details) =>
          _handleTapDown(keyNumber, details, soundFileName, keyColor),
      onTapUp: (details) => _handleTapUp(keyNumber, details),
      child: Transform.scale(
        scale: animation.value,
        child: Container(
          width: 180.0 + keyNumber * 10,
          height: 50.0,
          margin: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: keyColor,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 5.0,
                offset: const Offset(0.0, 5.0),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 12.5,
                height: 12.5,
                margin: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(6.25),
                ),
              ),
              Container(
                width: 12.5,
                height: 12.5,
                margin: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(6.25),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNote(int keyNumber, Color keyColor) {
    final note = Container(
      width: 50.0, // Ancho del círculo
      height: 50.0, // Altura del círculo
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: Center(
        child: Icon(
          Icons.music_note,
          color: keyColor,
          size: 30.0, // Tamaño del ícono
        ),
      ),
    );

    OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) {
        return Center(
          child: note,
        );
      },
      opaque: false,
      maintainState: true,
    );

    Overlay.of(context).insert(overlayEntry);

    Future.delayed(const Duration(seconds: 1), () {
      overlayEntry.remove();
    });
  }
}
