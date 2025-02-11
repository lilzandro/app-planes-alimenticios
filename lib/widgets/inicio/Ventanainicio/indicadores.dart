import 'package:app_planes/utils/dimensiones_pantalla.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart'; // Importa la librería de LinearPercentIndicator y CircularPercentIndicator

// Widget para el contenedor con barras de progreso lineales
Container buildProgressContainer() {
  return Container(
    color: Color(0xFF4da674),
    height: DimensionesDePantalla.pantallaSize * 0.25,
    child: Center(
      child: Column(
        children: [
          // EL NIVEL DE LA BARRA Y EL NIVEL MAXIMO
          buildCircularPercentIndicator(150, 0),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildLinearPercentIndicator("Carbohidratos", 0.8, 120),
                buildLinearPercentIndicator("Proteinas", 0.8, 120),
                buildLinearPercentIndicator("Grasas", 0.8, 120),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

// Widget para crear barras de progreso lineales
Widget buildLinearPercentIndicator(
    String nombre, double nivelDeProgreso, double metaProgreso) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        nombre,
        style: TextStyle(
            fontFamily: 'Comfortaa', color: Color(0xFFEAF8E7), fontSize: 12),
      ),
      LinearPercentIndicator(
        width: 120,
        lineHeight: 6,
        percent: nivelDeProgreso / 100,
        barRadius: Radius.circular(20),
        progressColor: Color(0xFFEAF8E7),
        backgroundColor: Color(0xFFEAF8E7).withOpacity(0.5),
      ),
      Text(
        "${nivelDeProgreso}g / ${metaProgreso}g",
        style: TextStyle(
          fontFamily: 'Comfortaa',
          color: Color(0xFFEAF8E7),
          fontSize: 12,
        ),
      )
    ],
  );
}

// Widget para crear el indicador circular
Widget buildCircularPercentIndicator(
    double nivelDeProgreso, double metaProgreso) {
  const Color progressColor = Color(0xFFEAF8E7);
  const TextStyle textStyleBase = TextStyle(
    fontFamily: 'Comfortaa',
    color: progressColor,
  );

  return CircularPercentIndicator(
    radius: 60,
    lineWidth: 6,
    percent: nivelDeProgreso / 1000,
    progressColor: progressColor,
    backgroundColor: progressColor.withOpacity(0.5),
    circularStrokeCap: CircularStrokeCap.round,
    center: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${nivelDeProgreso - metaProgreso}",
          style: textStyleBase.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          "Calorías",
          style: textStyleBase.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        ),
        Text(
          "restantes",
          style: textStyleBase.copyWith(fontSize: 10),
        ),
      ],
    ),
  );
}
