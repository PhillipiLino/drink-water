import 'package:flutter/material.dart';

import '../../utils/images.dart';

enum BottleSize {
  small(Images.smallBottleMask, Images.smallBottleOverlay, 0.5, '500 ml'),
  medium(Images.mediumBottleMask, Images.mediumBottleOverlay, 1, '1 litro'),
  big(Images.bigBottleMask, Images.bigBottleOverlay, 2, '2 litros');

  const BottleSize(this.imageMask, this.imageOverlay, this.limit, this.label);
  final AssetImage imageMask;
  final AssetImage imageOverlay;
  final double limit;
  final String label;
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
          child: Image(image: bottleSize.imageMask),
        ),
        Image(image: bottleSize.imageOverlay),
      ],
    );
  }
}
