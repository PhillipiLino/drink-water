import 'package:flutter/material.dart';
import 'package:my_components/my_components.dart';

import '../../utils/images.dart';
import 'default_button.dart';

enum GlassButtonSize {
  small(Images.smallGlass, 3.0, 190),
  medium(Images.mediumGlass, 1.0, 250),
  big(Images.bigGlass, 1.0, 350);

  const GlassButtonSize(this.image, this.padding, this.mls);
  final AssetImage image;
  final double padding;
  final double mls;
}

class GlassButton extends StatelessWidget {
  final Function(double) onPressed;
  final GlassButtonSize glassSize;

  const GlassButton(this.onPressed, this.glassSize, {super.key});

  @override
  Widget build(BuildContext context) {
    final spacings = ThemeManager.shared.theme.spacings;
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: DefaultButton(
            type: MyButtonType.secondary,
            onPressed: () => onPressed(glassSize.mls / 1000),
            child: Padding(
              padding: EdgeInsets.all(glassSize.padding),
              child: Image(image: glassSize.image),
            ),
          ),
        ),
        SizedBox(height: spacings.xxxsmall),
        Text('${glassSize.mls.toInt()} ml', style: MyTextStyle.tiny()),
      ],
    );
  }
}
