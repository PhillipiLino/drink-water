import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_components/my_components.dart';

class DefaultButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final MyButtonType type;

  const DefaultButton({
    required this.onPressed,
    required this.child,
    this.type = MyButtonType.primary,
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
    return MyButton(
      icon: widget.child,
      type: widget.type,
      onTapDown: () => timerAction(widget.onPressed),
      onTapUp: () => cancelTimer(),
      onTapCancel: cancelTimer,
      onPressed: widget.onPressed,
    );
  }
}
