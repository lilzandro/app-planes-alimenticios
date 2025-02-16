//// filepath: /C:/Users/lisan/Desktop/Workspaces/app_planes/lib/widgets/planAlimenticio/estadisticas_diarias.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DailyMealsWeeklyChart extends StatelessWidget {
  // Lista con 7 valores (índice 0: Lun, 1: Mar, ..., 6: Dom) que representa la cantidad de comidas consumidas diarias.
  final List<int> dailyMealsCount;

  const DailyMealsWeeklyChart({
    Key? key,
    required this.dailyMealsCount,
  }) : super(key: key);

  LinearGradient get _barsGradient => const LinearGradient(
        colors: [
          Color(0xFF5AC488),
          Color.fromARGB(255, 47, 243, 132),
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  Widget _getTitles(double value, TitleMeta meta) {
    final style = const TextStyle(
      color: Colors.blueGrey,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Lu';
        break;
      case 1:
        text = 'Ma';
        break;
      case 2:
        text = 'Mi';
        break;
      case 3:
        text = 'Ju';
        break;
      case 4:
        text = 'Vi';
        break;
      case 5:
        text = 'Sa';
        break;
      case 6:
        text = 'Do';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      fitInside: SideTitleFitInsideData.fromTitleMeta(meta),
      space: 4,
      meta: meta,
      child: Text(text, style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.8,
      child: BarChart(
        BarChartData(
          maxY:
              (dailyMealsCount.reduce((a, b) => a > b ? a : b) + 1).toDouble(),
          barGroups: List.generate(7, (index) {
            double y = index < dailyMealsCount.length
                ? dailyMealsCount[index].toDouble()
                : 0;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: y,
                  width: 16,
                  gradient: _barsGradient,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                getTitlesWidget: _getTitles,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: 1,
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          alignment: BarChartAlignment.spaceAround,
          barTouchData: BarTouchData(enabled: true),
        ),
      ),
    );
  }
}
