import 'package:flutter/material.dart';

class Bottle extends StatelessWidget {
  final double drinkedMls;
  final bool showLimit;

  const Bottle({
    required this.drinkedMls,
    this.showLimit = true,
    super.key,
  });

  final bottleLimit = 2;

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
                Colors.white,
              ],
              stops: [
                0.0,
                (drinkedMls / bottleLimit),
              ],
              tileMode: TileMode.mirror,
            ).createShader(bounds);
          },
          child: Image.asset('assets/images/bottle_mask.png'),
        ),
        Image.asset('assets/images/bottle_overlay.png'),
      ],
    );
  }
}
