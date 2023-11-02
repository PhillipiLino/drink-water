import 'package:flutter/material.dart';

enum DefaultButtonStyle {
  primary(Colors.black, Colors.white),
  secondary(Color.fromARGB(255, 234, 231, 231), Colors.black);

  const DefaultButtonStyle(this.backgroundColor, this.foregroundColor);
  final Color backgroundColor;
  final Color foregroundColor;
}

class DefaultButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final DefaultButtonStyle style;

  const DefaultButton({
    required this.onPressed,
    required this.child,
    this.style = DefaultButtonStyle.primary,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: style.backgroundColor,
          foregroundColor: style.foregroundColor,
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
