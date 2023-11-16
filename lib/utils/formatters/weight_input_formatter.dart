import 'package:flutter/services.dart';

import '../extensions/number_extensions.dart';
import '../extensions/string_extensions.dart';

class WeightInputFormatter extends TextInputFormatter {
  final bool allowNegative;

  WeightInputFormatter({
    this.allowNegative = false,
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    bool isNegative = newValue.text.contains('-');
    final digitsText = newValue.text.onlyDigits();

    final baseOffset = newValue.selection.baseOffset;
    final showZero = baseOffset == 0 && digitsText.isEmpty;
    num value = showZero ? 0 : int.parse(digitsText);

    value = value / 100;
    if (value == 0 || !allowNegative) isNegative = false;

    final preffix = isNegative ? '-' : '';
    String newText = value.toLocale();
    newText = '$preffix$newText';

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
