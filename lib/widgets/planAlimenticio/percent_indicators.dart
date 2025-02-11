import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

Widget buildCircularPercentIndicator(
  double nivelDeProgreso,
  String atributo,
  Color color,
) {
  const TextStyle textStyleBase = TextStyle(
    fontFamily: 'Comfortaa',
  );

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CircularPercentIndicator(
        radius: 30,
        lineWidth: 5,
        percent: nivelDeProgreso / nivelDeProgreso,
        progressColor: color,
        backgroundColor: color.withOpacity(0.5),
        circularStrokeCap: CircularStrokeCap.round,
        center: Text(
          "  ${nivelDeProgreso.toStringAsFixed(1)}g  ",
          style: textStyleBase.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
      SizedBox(height: 5),
      Text(
        atributo,
        style: textStyleBase.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    ],
  );
}

Widget buildLinearPercentIndicator(String nombre, double nivelDeProgreso) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        nombre,
        style: TextStyle(
            fontFamily: 'Comfortaa', color: Color(0xFFEAF8E7), fontSize: 12),
      ),
      Text(
        "${nivelDeProgreso.toInt()} Kcal",
        style: TextStyle(
          fontFamily: 'Comfortaa',
          color: Color(0xFF023336),
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      LinearPercentIndicator(
        width: 150,
        lineHeight: 8,
        percent: nivelDeProgreso / nivelDeProgreso,
        barRadius: Radius.circular(20),
        progressColor: Color(0xFF4DA674),
        backgroundColor: Color.fromARGB(255, 94, 199, 138).withOpacity(0.5),
      ),
      Text(
        "Calorias",
        style: TextStyle(
          fontFamily: 'Comfortaa',
          color: Color(0xFF023336),
          fontSize: 15,
        ),
      ),
    ],
  );
}
