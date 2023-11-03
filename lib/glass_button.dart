import 'package:flutter/material.dart';

import 'default_button.dart';

enum GlassButtonSize {
  small('assets/images/copo-americano.png', 12.0, 190),
  medium('assets/images/copo-medio.png', 8.0, 250),
  big('assets/images/copo-grande.png', 4.0, 350);

  const GlassButtonSize(this.image, this.padding, this.mls);
  final String image;
  final double padding;
  final double mls;
}

class GlassButton extends StatelessWidget {
  final Function(double) onPressed;
  final GlassButtonSize glassSize;

  const GlassButton(this.onPressed, this.glassSize, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: DefaultButton(
            style: DefaultButtonStyle.tertiary,
            onPressed: () => onPressed(glassSize.mls / 1000),
            child: Padding(
              padding: EdgeInsets.all(glassSize.padding),
              child: Image.asset(glassSize.image),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${glassSize.mls.toInt()} ml',
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
