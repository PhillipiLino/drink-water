import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_components/my_components.dart';

import '../../domain/models/day_drink.dart';
import '../../utils/extensions/number_extensions.dart';

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
    final theme = ThemeManager.shared.theme;
    final spacings = theme.spacings;
    final colors = theme.colors;
    const maxSize = 6;

    if (list.isEmpty) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: spacings.xsmall),
        padding: EdgeInsets.all(spacings.xxsmall),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(theme.borderRadius.regular),
          border: Border.all(
            color: colors.elementsColors.lineAndBorders,
            width: 1,
          ),
        ),
        child: const Center(child: Text('Sem dados salvos até o momento')),
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

    return Container(
      margin: EdgeInsets.symmetric(horizontal: spacings.xsmall),
      padding: EdgeInsets.all(spacings.xxsmall),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(theme.borderRadius.regular),
        border: Border.all(
          color: colors.elementsColors.lineAndBorders,
          width: 1,
        ),
      ),
      child: MyBarChart(
        goal: goalToSet,
        items: items,
        selectedXValue: currentDate,
        scrollController: scrollController,
        onTapBar: (index, data) => onTapBar?.call(index, data),
        yLabelBuilder: (index) {
          final itemValue = newList[index].drinkedMls;
          final textColor = itemValue.getDrinkedValueColor(goal);

          return SizedBox(
            width: 40,
            child: Text(
              newList[index].drinkedMls.toStringAsFixed(2),
              style: MyTextStyle.small(color: textColor),
              textAlign: TextAlign.center,
            ),
          );
        },
        xLabelBuilder: (index) {
          final itemValue = items[index].xValue.substring(0, 5);

          return SizedBox(
            width: 35,
            child: Text(
              itemValue,
              style: MyTextStyle.tiny(),
            ),
          );
        },
      ),
    );
  }
}
