import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_components/my_components.dart';

import 'day_drink.dart';

class DayDrinkChart extends StatelessWidget {
  final List<DayDrink> list;
  final double goal;
  final String currentDate;
  final Function(int index, MyChartData data)? onTapBar;
  final ScrollController scrollController;

  DayDrinkChart(
    this.list,
    this.goal,
    this.currentDate, {
    this.onTapBar,
    required this.scrollController,
    super.key,
  });

  final dateFormtat = DateFormat('dd/MM/yyyy');

  List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  }

  @override
  Widget build(BuildContext context) {
    final colors = ThemeManager.shared.theme.colors;
    const maxSize = 6;

    if (list.isEmpty) {
      return const Center(
        child: Text('Sem dados salvos até o momento'),
      );
    }

    final firstDate = dateFormtat.parse(list.first.date);
    final lastDate = dateFormtat.parse(list.last.date);
    final dateList = getDaysInBetween(firstDate, lastDate)
        .map((e) => dateFormtat.format(e))
        .toList();

    var result = {for (var v in list) v.date: v.drinkedMls};

    List<DayDrink> newList = [];
    for (var date in dateList) {
      final value = result[date] ?? 0;
      newList.add(DayDrink(date, value));
    }

    final items = newList
        .map(
          (e) => MyChartData(e.date, (e.drinkedMls / maxSize)),
        )
        .toList();

    final goalToSet = goal / maxSize;

    return MyBarChart(
      goal: goalToSet,
      items: items,
      selectedXValue: currentDate,
      scrollController: scrollController,
      onTapBar: (index, data) {
        onTapBar?.call(index, data);
      },
      yLabelBuilder: (index) {
        final itemValue = newList[index].drinkedMls;

        Color textColor = colors.feedbackColors.success.dark;

        if (itemValue <= 1) textColor = colors.feedbackColors.attention.dark;
        if (itemValue > 1 && itemValue < 2) textColor = colors.energy;
        if (itemValue >= 2 && itemValue < goal) textColor = colors.primary;

        return Text(
          '${newList[index].drinkedMls.toStringAsFixed(2)} L',
          style: MyTextStyle.regular(color: textColor),
        );
      },
      xLabelBuilder: (index) {
        final itemValue = items[index].xValue.substring(0, 5);

        return Text(
          itemValue,
          style: MyTextStyle.regular(),
        );
      },
    );
  }
}
