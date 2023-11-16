import 'package:intl/intl.dart';

extension NullableStringExtension on String? {
  bool matchRegex(String regex) => RegExp(regex).hasMatch(this ?? '');

  num fromCurrency([String locale = 'pt_Br']) {
    NumberFormat currencyFormatter =
        NumberFormat.simpleCurrency(locale: locale);

    final noBreakSpace = String.fromCharCode(0x00A0);
    final text = this?.replaceAll(' ', noBreakSpace) ?? '';

    try {
      return currencyFormatter.parse(text);
    } catch (e) {
      return 0;
    }
  }

  String removeDiacritics() {
    var text = this;
    var withDia =
        'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    var withoutDia =
        'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

    for (int i = 0; i < withDia.length; i++) {
      text = text?.replaceAll(withDia[i], withoutDia[i]);
    }

    return text ?? '';
  }

  String onlyDigits() => this?.replaceAll(RegExp(r'\D'), '') ?? '';

  String removeSpecialChars() =>
      this?.replaceAll(RegExp('[^A-Za-z0-9]'), '') ?? '';

  String? changeDateFormat(String currentDateFormat, String newDateFormat) {
    final currentFormat = DateFormat(currentDateFormat);
    final newFormat = DateFormat(newDateFormat);

    try {
      final currentDateTime = currentFormat.parse(this ?? '');
      return newFormat.format(currentDateTime);
    } catch (e) {
      return null;
    }
  }
}
