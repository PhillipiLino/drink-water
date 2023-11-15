import 'package:drink_water/default_button.dart';
import 'package:flutter/material.dart';
import 'package:my_components/my_components.dart';

enum GlassButtonSize {
  small('assets/images/copo-americano.png', 3.0, 190),
  medium('assets/images/copo-medio.png', 1.0, 250),
  big('assets/images/copo-grande.png', 1.0, 350);

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
            type: MyButtonType.secondary,
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
