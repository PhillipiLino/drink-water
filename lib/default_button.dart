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
  Timer? _timer;

  timerAction(VoidCallback action) {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (t) {
      action();
    });
  }

  cancelTimer() {
    _timer?.cancel();
    _timer = null;
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
        height: MediaQuery.of(context).size.height * 0.08,
        child: AspectRatio(
          aspectRatio: 0.9,
          child: Material(
            color: widget.style.backgroundColor,
            child: InkWell(
              onTapDown: (_) => timerAction(widget.onPressed),
              onTapUp: (_) => cancelTimer(),
              onTapCancel: cancelTimer,
              onTap: widget.onPressed,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
