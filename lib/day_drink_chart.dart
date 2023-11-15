import 'package:drink_water/day_drink.dart';
import 'package:drink_water/number_extensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:my_components/my_components.dart';

class DayDrinkChart extends StatelessWidget {
  final List<DayDrink> list;
  final double goal;
  const DayDrinkChart(this.list, this.goal, {super.key});

  @override
  Widget build(BuildContext context) {
    final colors = ThemeManager.shared.theme.colors;
    const maxSize = 6;
    final items =
        list.map((e) => MyChartData(e.date, (e.drinkedMls / maxSize))).toList();

    final goalToSet = goal / maxSize;

    return MyBarChart(
      goal: goalToSet,
      items: items,
      yLabelBuilder: (index) {
        final itemValue = list[index].drinkedMls;
        Color textColor = colors.feedbackColors.success.dark;

        if (itemValue <= 1) textColor = colors.feedbackColors.attention.dark;
        if (itemValue > 1 && itemValue < 2) textColor = colors.energy;
        if (itemValue >= 2 && itemValue < goal) textColor = colors.primary;

        return Text(
          '${list[index].drinkedMls.toStringAsFixed(2)} L',
          style: MyTextStyle.regular(color: textColor),
        );
      },
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            Color textColor = Colors.blue;

            if (rod.toY <= 1) textColor = Colors.red;

            if (rod.toY > 1 && rod.toY < 2) {
              textColor = const Color.fromARGB(255, 222, 168, 4);
            }

            return BarTooltipItem(
              '${rod.toY.toLocale()} L',
              TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w300,
      fontSize: 14,
    );
    String text;
    text = list[value.toInt()].date.substring(0, 5);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(show: false);

  LinearGradient _barsGradient(double value) {
    Color topColor = Colors.cyan;
    Color bottomColor = Colors.blue;

    if (value <= 1) {
      topColor = const Color.fromARGB(255, 255, 175, 187);
      bottomColor = Colors.red;
    }

    if (value > 1 && value < 2) {
      topColor = const Color.fromARGB(255, 253, 220, 119);
      bottomColor = Colors.amber;
    }

    return LinearGradient(
      colors: [
        bottomColor,
        topColor,
      ],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    );
  }

  List<BarChartGroupData> get barGroups => list
      .asMap()
      .map(
        (key, value) => MapEntry(
          key,
          BarChartGroupData(
            x: key,
            barRods: [
              BarChartRodData(
                toY: value.drinkedMls,
                gradient: _barsGradient(value.drinkedMls),
                width: 10,
              )
            ],
            showingTooltipIndicators: [0],
          ),
        ),
      )
      .values
      .toList();
}
