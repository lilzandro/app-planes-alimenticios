import 'package:app_planes/utils/dimensiones_pantalla.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart'; // Importa la librería de LinearPercentIndicator y CircularPercentIndicator

// Widget para el contenedor con barras de progreso lineales
Container buildProgressContainer(totalCalorias, double totalCarbohidratos,
    double totalProteinas, double totalGrasas) {
  return Container(
    color: Color(0xFF4da674),
    height: DimensionesDePantalla.pantallaSize * 0.25,
    child: Center(
      child: Column(
        children: [
          SizedBox(
            height: DimensionesDePantalla.pantallaSize * 0.01,
          ),
          // EL NIVEL DE LA BARRA Y EL NIVEL MAXIMO
          buildCircularPercentIndicator(1000, (totalCalorias).toInt()),
          Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildLinearPercentIndicator(
                    "Carbohidratos", 20, (totalCarbohidratos).toInt()),
                buildLinearPercentIndicator(
                    "Proteinas", 20, (totalProteinas).toInt()),
                buildLinearPercentIndicator(
                    "Grasas", 20, (totalGrasas).toInt()),
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
    String nombre, int nivelDeProgreso, int metaProgreso) {
  double porcentaje = (nivelDeProgreso / metaProgreso).clamp(0.0, 1.0);

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
        percent: porcentaje,
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
Widget buildCircularPercentIndicator(int caloriasActuales, int metaCalorias) {
  const Color progressColor = Color(0xFFEAF8E7);
  const TextStyle textStyleBase = TextStyle(
    fontFamily: 'Comfortaa',
    color: progressColor,
  );

  // Calcula el porcentaje, asegurando que se encuentre entre 0 y 1
  double porcentaje = (caloriasActuales / metaCalorias).clamp(0.0, 1.0);

  return CircularPercentIndicator(
    radius: 60,
    lineWidth: 6,
    percent: porcentaje,
    progressColor: progressColor,
    backgroundColor: progressColor.withOpacity(0.5),
    circularStrokeCap: CircularStrokeCap.round,
    center: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "$caloriasActuales / $metaCalorias",
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
          "consumidas",
          style: textStyleBase.copyWith(fontSize: 10),
        ),
      ],
    ),
  );
}
