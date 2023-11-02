import 'package:flutter/material.dart';

class Bottle extends StatelessWidget {
  final double drinkedMls;
  final bool showLimit;

  const Bottle({
    required this.drinkedMls,
    this.showLimit = true,
    super.key,
  });

  final bottleLimit = 2000;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/images/bottle.png',
        ),
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
          child: Image.asset('assets/images/bottle.png'),
        ),
        if (showLimit)
          const Positioned.fill(
            child: Center(
              child: SizedBox(
                child: Text(
                  '2 Litros',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.lightBlue,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}