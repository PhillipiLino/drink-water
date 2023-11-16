import 'dart:ui';

import 'package:intl/intl.dart';
import 'package:my_components/my_components.dart';

extension NumExtensions on num? {
  String toCurrency({
    String locale = 'pt_Br',
    bool showDecimals = true,
  }) {
    NumberFormat currencyFormatter = NumberFormat.simpleCurrency(
      locale: locale,
      decimalDigits: showDecimals ? 2 : 0,
    );
    final noBreakSpace = String.fromCharCode(0x00A0);

    try {
      final formatted =
          currencyFormatter.format(this).replaceAll(noBreakSpace, ' ');

      return formatted;
    } catch (e) {
      return currencyFormatter.format(0).replaceAll(noBreakSpace, ' ');
    }
  }

  String toLocale({String locale = 'pt_Br', bool showDecimals = true}) {
    final value = showDecimals ? this : this?.floor();
    NumberFormat formatter = NumberFormat(null, locale);

    formatter.minimumIntegerDigits = 1;
    formatter.minimumFractionDigits = showDecimals ? 2 : 0;
    formatter.maximumFractionDigits = showDecimals ? 2 : 0;

    try {
      return formatter.format(value);
    } catch (e) {
      return formatter.format(0);
    }
  }

  String toPercent({String locale = 'pt_Br', bool showDecimals = true}) {
    final value = (this as double? ?? 0).toLocale(
      locale: locale,
      showDecimals: showDecimals,
    );

    return '$value %';
  }

  String numToString({int pad = 0}) => toString().padLeft(pad, '0');

  Color getDrinkedValueColor(double goal) {
    final value = this ?? 0;
    final colors = ThemeManager.shared.theme.colors;
    Color textColor = colors.feedbackColors.success.dark;

    if (value <= 1) textColor = colors.feedbackColors.attention.dark;
    if (value > 1 && value < 2) textColor = colors.energy;
    if (value >= 2 && value < goal) textColor = colors.primary;

    return textColor;
  }
}
