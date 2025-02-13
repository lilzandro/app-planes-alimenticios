import 'package:app_planes/widgets/inicio/Ventanainicio/vetanaInferior.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:app_planes/utils/dimensiones_pantalla.dart';
import 'package:app_planes/utils/linea.dart';
import 'package:app_planes/models/planAlimenticioModel.dart';

class DayDetailScreen extends StatelessWidget {
  final String dayString;
  final String daysOfWeek;
  final PlanAlimenticioModel planAlimenticio;
  final DateTime selectedDate;

  const DayDetailScreen.planDia({
    super.key,
    required this.dayString,
    required this.daysOfWeek,
    required this.planAlimenticio,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    // Filtrar las comidas por la fecha seleccionada
    PlanDiario? desayuno = planAlimenticio.desayuno
        .firstWhere((comida) => comida.fecha == selectedDate,
            orElse: () => PlanDiario(
                  nombreReceta: '',
                  imagenReceta: '',
                  ingredientes: [],
                  informacionIngredientes: [],
                  nutrientes: {},
                  gramosComida: 0.0,
                  proporcionComida: 0.0,
                  fecha: selectedDate,
                  intrucciones: [],
                ));
    PlanDiario? almuerzo = planAlimenticio.almuerzo
        .firstWhere((comida) => comida.fecha == selectedDate,
            orElse: () => PlanDiario(
                  nombreReceta: '',
                  imagenReceta: '',
                  ingredientes: [],
                  informacionIngredientes: [],
                  nutrientes: {},
                  gramosComida: 0.0,
                  proporcionComida: 0.0,
                  fecha: selectedDate,
                  intrucciones: [],
                ));
    PlanDiario? cena = planAlimenticio.cena
        .firstWhere((comida) => comida.fecha == selectedDate,
            orElse: () => PlanDiario(
                  nombreReceta: '',
                  imagenReceta: '',
                  ingredientes: [],
                  informacionIngredientes: [],
                  nutrientes: {},
                  gramosComida: 0.0,
                  proporcionComida: 0.0,
                  fecha: selectedDate,
                  intrucciones: [],
                ));
    PlanDiario? merienda = planAlimenticio.merienda1
        .firstWhere((comida) => comida.fecha == selectedDate,
            orElse: () => PlanDiario(
                  nombreReceta: '',
                  imagenReceta: '',
                  ingredientes: [],
                  informacionIngredientes: [],
                  nutrientes: {},
                  gramosComida: 0.0,
                  proporcionComida: 0.0,
                  fecha: selectedDate,
                  intrucciones: [],
                ));

    return Scaffold(
      backgroundColor: const Color(0xFFeaf8e7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFeaf8e7),
        title: Text(
          'Plan de alimentación: $daysOfWeek',
          style: TextStyle(
            color: const Color(0xFF023336),
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            _buildCalendarWidget(context, desayuno, almuerzo, cena, merienda),
      ),
    );
  }

  Widget _buildCalendarWidget(BuildContext context, PlanDiario? desayuno,
      PlanDiario? almuerzo, PlanDiario? cena, PlanDiario? merienda) {
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
                    color: const Color(0xFF023336), // Color del borde
                    width: 1.5, // Grosor del borde
                  ),
                  // Borde verde
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
                    if (desayuno != null &&
                        desayuno.nombreReceta.isNotEmpty) ...[
                      _buildMealSection(
                        'Desayuno',
                        'Descripción del desayuno',
                        desayuno.imagenReceta,
                        const Color(0xFFeaf8e7),
                        desayuno.imagenReceta,
                        'Desayuno',
                        [desayuno],
                        context,
                        desayuno.nombreReceta,
                        desayuno.nutrientes,
                        desayuno.gramosComida,
                        desayuno.proporcionComida,
                      ),
                      linea(1, .8),
                    ],
                    if (almuerzo != null &&
                        almuerzo.nombreReceta.isNotEmpty) ...[
                      _buildMealSection(
                        'Almuerzo',
                        'Descripción del almuerzo',
                        almuerzo.imagenReceta,
                        const Color(0xFFeaf8e7),
                        almuerzo.imagenReceta,
                        'Almuerzo',
                        [almuerzo],
                        context,
                        almuerzo.nombreReceta,
                        almuerzo.nutrientes,
                        almuerzo.gramosComida,
                        almuerzo.proporcionComida,
                      ),
                      linea(1, .8),
                    ],
                    if (cena != null && cena.nombreReceta.isNotEmpty) ...[
                      _buildMealSection(
                        'Cena',
                        'Descripción de la cena',
                        cena.imagenReceta,
                        const Color(0xFFeaf8e7),
                        cena.imagenReceta,
                        'Cena',
                        [cena],
                        context,
                        cena.nombreReceta,
                        cena.nutrientes,
                        cena.gramosComida,
                        cena.proporcionComida,
                      ),
                      linea(1, .8),
                    ],
                    if (merienda != null &&
                        merienda.nombreReceta.isNotEmpty) ...[
                      _buildMealSection(
                        'Merienda',
                        'Descripción de la merienda',
                        merienda.imagenReceta,
                        const Color(0xFFeaf8e7),
                        merienda.imagenReceta,
                        'Merienda',
                        [merienda],
                        context,
                        merienda.nombreReceta,
                        merienda.nutrientes,
                        merienda.gramosComida,
                        merienda.proporcionComida,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMealSection(
    String mealName,
    String mealDescription,
    String imgComida,
    Color color,
    String imagePath,
    String selectedMeal,
    List<PlanDiario> planDiario,
    BuildContext context,
    String nombreReceta,
    Map<String, dynamic> nutrientes,
    double gramosComida,
    double proporcionComida,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: DimensionesDePantalla.pantallaSize * 0.03),
          SizedBox(
            height: DimensionesDePantalla.pantallaSize *
                0.16, // Ancho fijo para el nombre de la comida
            child: Column(
              children: [
                ClipOval(
                  child: imagePath.startsWith('http')
                      ? CachedNetworkImage(
                          imageUrl: imagePath,
                          height: DimensionesDePantalla.anchoPantalla * .2,
                          width: DimensionesDePantalla.anchoPantalla * .22,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/$mealName.png',
                            height: DimensionesDePantalla.anchoPantalla * .2,
                            width: DimensionesDePantalla.anchoPantalla * .22,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.asset(
                          imagePath,
                          height: DimensionesDePantalla.anchoPantalla * .15,
                          width: DimensionesDePantalla.anchoPantalla * .16,
                          fit: BoxFit.cover,
                        ),
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
                SizedBox(
                  height: DimensionesDePantalla.pantallaSize * 0.035,
                  child: ElevatedButton(
                    onPressed: () {
                      showMealBottomSheet(
                        context: context,
                        mealName: mealName,
                        imagePath: imagePath,
                        imageEr: 'assets/$mealName.png',
                        selectedMeal: selectedMeal,
                        color: Colors.transparent,
                        planDiario: [],
                        receta: nombreReceta,
                        gramosComida: gramosComida,
                        nutrientes: nutrientes,
                        proporcionComida: proporcionComida,
                        informacionIngredientes: [],
                        intrucciones: [],
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF023336), // Fondo blanco
                    ),
                    child: Text(
                      'Ver detalles',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFeaf8e7),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: DimensionesDePantalla.pantallaSize * 0.03),
          SizedBox(
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
