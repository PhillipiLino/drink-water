import 'package:flutter/material.dart';

enum BottleSize {
  small(
    'assets/images/small_bottle_mask.png',
    'assets/images/small_bottle_overlay.png',
    0.25,
  ),
  medium(
    'assets/images/medium_bottle_mask.png',
    'assets/images/medium_bottle_overlay.png',
    1,
  ),
  big('assets/images/bottle_mask.png', 'assets/images/bottle_overlay.png', 2);

  const BottleSize(this.imageMask, this.imageOverlay, this.limit);
  final String imageMask;
  final String imageOverlay;
  final double limit;
}

class Bottle extends StatelessWidget {
  final double drinkedMls;

  final BottleSize bottleSize;

  const Bottle({
    required this.drinkedMls,
    this.bottleSize = BottleSize.big,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: const [
                Color.fromARGB(255, 129, 203, 222),
                Color.fromARGB(255, 129, 203, 222),
                Colors.white,
              ],
              stops: [
                0.0,
                (drinkedMls / bottleSize.limit) - 0.1,
                (drinkedMls / bottleSize.limit),
              ],
              tileMode: TileMode.mirror,
            ).createShader(bounds);
          },
          child: Image.asset(bottleSize.imageMask),
        ),
        Image.asset(bottleSize.imageOverlay),
      ],
    );
  }
}
