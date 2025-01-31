import 'package:flutter/material.dart';
import 'package:app_planes/utils/dimensiones_pantalla.dart';
import 'package:app_planes/utils/linea.dart';

class DayDetailScreen extends StatelessWidget {
  final String dayString;

  const DayDetailScreen.planDia({Key? key, required this.dayString})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFeaf8e7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFeaf8e7),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildCalendarWidget(),
      ),
    );
  }

  Widget _buildCalendarWidget() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: EdgeInsets.symmetric(
              horizontal: DimensionesDePantalla.pantallaSize * 0.01),
          decoration: BoxDecoration(),
          child: Column(
            children: [
              SizedBox(height: DimensionesDePantalla.pantallaSize * 0.025),
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFeaf8e7), // Fondo blanco
                  borderRadius: BorderRadius.circular(
                    DimensionesDePantalla.pantallaSize * 0.03,
                  ),
                  border: Border.all(
                    color: const Color(0xFF023336),
                    width: 2,
                  ), // Borde verde
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(4.0),
                      height: DimensionesDePantalla.pantallaSize * 0.06,
                      width: DimensionesDePantalla.pantallaSize * 0.4,
                      decoration: BoxDecoration(
                        border: const Border(
                          bottom: BorderSide(
                            color: Color(0xFF023336), // Color del borde
                            width: 3.0, // Grosor del borde
                          ),
                        ),
                        color: const Color(0xFF4da674),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(26.0),
                          topRight: Radius.circular(26.0),
                        ),
                      ),
                      child: Text(
                        dayString, // Mostrar la fecha calculada
                        style: const TextStyle(
                          fontFamily: 'Comfortaa',
                          color: Color(0xFFeaf8e7), // Texto blanco
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    _buildMealSection('Desayuno', 'Descripción del desayuno',
                        'assets/desayuno.png'),
                    linea(.8, .8),
                    _buildMealSection('Almuerzo', 'Descripción del almuerzo',
                        'assets/almuerzo.png'),
                    linea(.8, .8),
                    _buildMealSection(
                        'Cena', 'Descripción de la cena', 'assets/cena.png'),
                    linea(.8, .8),
                    _buildMealSection('Merienda', 'Descripción de la merienda',
                        'assets/merienda.png'),
                  ],
                ),
              ),
              SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMealSection(
    String mealName,
    String mealDescription,
    String imagePath,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: DimensionesDePantalla.pantallaSize * 0.03),
          Container(
              height: DimensionesDePantalla.pantallaSize *
                  0.16, // Ancho fijo para el nombre de la comida
              child: Column(children: [
                Image.asset(
                  imagePath,
                  height: DimensionesDePantalla.anchoPantalla * .2,
                  width: DimensionesDePantalla.anchoPantalla * .22,
                ),
                Text(
                  mealName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF023336),
                  ),
                ),
              ])),
          SizedBox(width: DimensionesDePantalla.pantallaSize * 0.03),
          Container(
            alignment: Alignment.topCenter,
            height: DimensionesDePantalla.pantallaSize *
                0.16, // Ancho fijo para la descripción de la comida
            child: Text(
              mealDescription,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF023336),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
