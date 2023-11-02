import 'dart:math';

import 'package:drink_water/day_drink.dart';
import 'package:drink_water/number_extensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DayDrinkChart extends StatelessWidget {
  final List<DayDrink> list;
  const DayDrinkChart(this.list, {super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 1.5 * 25 * list.length,
        child: BarChart(
          BarChartData(
            barTouchData: barTouchData,
            titlesData: titlesData,
            borderData: borderData,
            barGroups: barGroups,
            gridData: const FlGridData(show: false),
            alignment: BarChartAlignment.spaceBetween,
            maxY: list.map((e) => e.drinkedMls).reduce(max) + 1.8,
          ),
        ),
      ),
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
