import 'package:app_planes/utils/dimensiones_pantalla.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart'; // Importa la librería de LinearPercentIndicator y CircularPercentIndicator

// Widget para el contenedor con barras de progreso lineales
Container buildProgressContainer(
  double progresoCalorias,
  double metaCalorias,
  double progresoCarbohidratos,
  double totalCarbohidratos,
  double progresoProteinas,
  double totalProteinas,
  double totalGrasas,
  double grasasProgreso,
) {
  return Container(
    color: const Color(0xFF4da674),
    child: Center(
      child: Column(
        children: [
          SizedBox(
            height: DimensionesDePantalla.pantallaSize * 0.01,
          ),
          buildCircularPercentIndicator(
              progresoCalorias.toInt(), metaCalorias.toInt()),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildLinearPercentIndicator("Carbohidratos",
                    progresoCarbohidratos.toInt(), totalCarbohidratos.toInt()),
                buildLinearPercentIndicator("Proteínas",
                    progresoProteinas.toInt(), totalProteinas.toInt()),
                buildLinearPercentIndicator(
                    "Grasas", grasasProgreso.toInt(), totalGrasas.toInt()),
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
        style: const TextStyle(
            fontFamily: 'Comfortaa', color: Color(0xFFEAF8E7), fontSize: 12),
      ),
      LinearPercentIndicator(
        width: 120,
        lineHeight: 6,
        percent: porcentaje,
        barRadius: const Radius.circular(20),
        progressColor: const Color(0xFFEAF8E7),
        backgroundColor: const Color(0xFFEAF8E7).withOpacity(0.5),
      ),
      Text(
        "${nivelDeProgreso}g / ${metaProgreso}g",
        style: const TextStyle(
          fontFamily: 'Comfortaa',
          color: Color(0xFFEAF8E7),
          fontSize: 12,
        ),
      )
    ],
  );
}

// Widget para crear el indicador circular
Widget buildCircularPercentIndicator(int progresoCalorias, int metaCalorias) {
  const Color progressColor = Color(0xFFEAF8E7);
  const TextStyle textStyleBase = TextStyle(
    fontFamily: 'Comfortaa',
    color: progressColor,
  );

  double porcentaje = (progresoCalorias / metaCalorias).clamp(0.0, 1.0);

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
        SizedBox(
          height: 5,
        ),
        Text(
          "$progresoCalorias / $metaCalorias",
          style: textStyleBase.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        Text(
          "Calorías",
          style: textStyleBase.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        Text(
          "Diarias",
          style:
              textStyleBase.copyWith(fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ],
    ),
  );
}
