import 'package:codsoft_music_player/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GradientFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isPlaying;
  final Gradient gradient;

  const GradientFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.isPlaying,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: ShapeDecoration(
        shape: const CircleBorder(),
        gradient: gradient,
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: IconButton(
          icon: AnimatedSwitcher(
            duration:const  Duration(milliseconds: 200),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: GetBuilder<MainController>(
              builder: (controller) => Icon(
                controller.isPlaying ? Icons.pause : Icons.play_arrow,
                key: ValueKey<bool>(isPlaying),
                size: 50,
              ),
            )
          ),
          color: Colors.white,
          onPressed: onPressed,
        ),
      ),
    );
  }
}