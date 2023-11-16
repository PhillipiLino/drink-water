import 'package:flutter/material.dart';
import 'package:my_components/my_components.dart';

import 'glass_button.dart';

class GlassButtonsList extends StatelessWidget {
  final Function(double) onPressButton;

  const GlassButtonsList(this.onPressButton, {super.key});

  @override
  Widget build(BuildContext context) {
    final spacings = ThemeManager.shared.theme.spacings;
    final list = GlassButtonSize.values.toList().reversed.toList();

    return SizedBox(
      width: 60,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: list.length,
        separatorBuilder: (_, __) => SizedBox(height: spacings.small),
        itemBuilder: (_, index) => GlassButton(onPressButton, list[index]),
      ),
    );
  }
}
