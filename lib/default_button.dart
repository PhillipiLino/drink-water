import 'dart:async';

import 'package:flutter/material.dart';

enum DefaultButtonStyle {
  primary(Colors.black, Colors.white),
  secondary(Color.fromARGB(255, 234, 231, 231), Colors.black);

  const DefaultButtonStyle(this.backgroundColor, this.foregroundColor);
  final Color backgroundColor;
  final Color foregroundColor;
}

class DefaultButton extends StatefulWidget {
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
  State<DefaultButton> createState() => _DefaultButtonState();
}

class _DefaultButtonState extends State<DefaultButton> {
  Timer _timer = Timer(const Duration(milliseconds: 0), () {});

  timerAction(VoidCallback action) {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (t) {
      action();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        iconTheme: IconThemeData(color: widget.style.foregroundColor),
      ),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: const ShapeDecoration(
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
        ),
        height: 80,
        width: 70,
        child: Material(
          color: widget.style.backgroundColor,
          child: InkWell(
            onTapDown: (_) => timerAction(widget.onPressed),
            onTapUp: (_) => _timer.cancel(),
            onTapCancel: _timer.cancel,
            onTap: widget.onPressed,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
