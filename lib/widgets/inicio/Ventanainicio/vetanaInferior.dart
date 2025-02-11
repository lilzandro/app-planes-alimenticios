import 'package:app_planes/models/planAlimenticioModel.dart';
import 'package:app_planes/widgets/planAlimenticio/percent_indicators.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:app_planes/utils/dimensiones_pantalla.dart';

/// Función para mostrar el BottomSheet.
void showMealBottomSheet({
  required BuildContext context,
  required String mealName,
  required String imagePath,
  required String selectedMeal,
  required Color color,
  required List<PlanDiario> planDiario,
  required String imageEr,
  required String receta,
  required double gramosComida,
  required Map<String, dynamic> nutrientes,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Permitir usar más espacio de la pantalla
    enableDrag: false, // Desactivar el deslizamiento para cerrar
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300), // Duración de la animación
        curve: Curves.easeInOut, // Curva de la animación
        decoration: BoxDecoration(
          color: const Color(0xFFEAF8E7),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Stack(
          children: [
            // Contenido del BottomSheet
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 30), // Espacio para el botón "X"
                    Text(
                      mealName,
                      style: const TextStyle(
                        fontFamily: 'Comfortaa',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF023336),
                      ),
                    ),
                    SizedBox(height: DimensionesDePantalla.pantallaSize * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildLinearPercentIndicator("Calorías",
                            nutrientes['ENERC_KCAL']?['quantity'] ?? 0.0),
                      ],
                    ),
                    SizedBox(height: DimensionesDePantalla.pantallaSize * 0.04),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildCircularPercentIndicator(
                            nutrientes['PROCNT']?['quantity'] ?? 0.0,
                            "Proteínas",
                            const Color(0xFF8AA64D)),
                        buildCircularPercentIndicator(
                            nutrientes['CHOCDF']?['quantity'] ?? 0.0,
                            "Carbohidratos",
                            const Color(0xFF4D7EA6)),
                        buildCircularPercentIndicator(
                            nutrientes['FAT']?['quantity'] ?? 0.0,
                            "Grasas",
                            const Color(0xFFA64D7C)),
                        buildCircularPercentIndicator(
                            nutrientes['FIBTG']?['quantity'] ?? 0.0,
                            "Fibra dietetica",
                            const Color.fromARGB(255, 107, 77, 166)),
                      ],
                    ),
                    SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
                    _buildSeparator(DimensionesDePantalla.anchoPantalla),
                    SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
                    Container(
                      height: DimensionesDePantalla.pantallaSize * .08,
                      color: selectedMeal == mealName
                          ? color
                          : const Color.fromARGB(0, 188, 17, 17),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          imagePath.startsWith('http')
                              ? Padding(
                                  padding: EdgeInsets.only(
                                      left:
                                          DimensionesDePantalla.anchoPantalla *
                                              .03,
                                      right:
                                          DimensionesDePantalla.anchoPantalla *
                                              .03),
                                  // Espacio a la derecha de la imagen
                                  child: ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: imagePath,
                                      height:
                                          DimensionesDePantalla.anchoPantalla *
                                              .15,
                                      width:
                                          DimensionesDePantalla.anchoPantalla *
                                              .16,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        imageEr, // Ruta de tu imagen local
                                        height: DimensionesDePantalla
                                                .anchoPantalla *
                                            .15,
                                        width: DimensionesDePantalla
                                                .anchoPantalla *
                                            .16,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                )
                              : Image.asset(
                                  imagePath,
                                  height:
                                      DimensionesDePantalla.anchoPantalla * .2,
                                  width:
                                      DimensionesDePantalla.anchoPantalla * .22,
                                  fit: BoxFit.cover,
                                ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  receta,
                                  style: const TextStyle(
                                    fontFamily: 'Comfortaa',
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF023336),
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
                    _buildSeparator(DimensionesDePantalla.anchoPantalla),
                    _buildInformacionNutricional(nutrientes),
                  ],
                ),
              ),
            ),
            // Botón de cierre (posición fija en la esquina superior izquierda)
            Positioned(
              top: 30,
              left: 10,
              child: IconButton(
                icon: Icon(Icons.close, color: Color(0xFF023336), size: 30),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

// Definición de los métodos auxiliares (separadores y progress indicators).
Widget _buildSeparator(double anchoPantalla) {
  return Container(
    width: anchoPantalla * .9,
    height: .8,
    color: const Color(0xFF4DA674).withOpacity(0.5),
  );
}

Widget _buildInformacionNutricional(Map<String, dynamic> nutrientes) {
  // Clasificación de nutrientes por categorías y subcategorías
  Map<String, Map<String, double>> categorias = {
    'Grasas': {
      'Total': nutrientes['FAT']?['quantity'] ?? 0.0,
      'Saturated': nutrientes['FASAT']?['quantity'] ?? 0.0,
      'Trans': nutrientes['FATRN']?['quantity'] ?? 0.0,
      'Monounsaturated': nutrientes['FAMS']?['quantity'] ?? 0.0,
      'Polyunsaturated': nutrientes['FAPU']?['quantity'] ?? 0.0,
    },
    'Carbohidratos y Azúcares': {
      'Carbohydrates (net)': nutrientes['CHOCDF']?['quantity'] ?? 0.0,
      'Sugars': nutrientes['SUGAR']?['quantity'] ?? 0.0,
    },
    'Minerales': {
      'Cholesterol': nutrientes['CHOLE']?['quantity'] ?? 0.0,
      'Sodium': nutrientes['NA']?['quantity'] ?? 0.0,
      'Calcium': nutrientes['CA']?['quantity'] ?? 0.0,
      'Magnesium': nutrientes['MG']?['quantity'] ?? 0.0,
      'Potassium': nutrientes['K']?['quantity'] ?? 0.0,
      'Iron': nutrientes['FE']?['quantity'] ?? 0.0,
      'Zinc': nutrientes['ZN']?['quantity'] ?? 0.0,
      'Phosphorus': nutrientes['P']?['quantity'] ?? 0.0,
    },
    'Vitaminas': {
      'Vitamin A': nutrientes['VITA_RAE']?['quantity'] ?? 0.0,
      'Vitamin C': nutrientes['VITC']?['quantity'] ?? 0.0,
      'Thiamin (B1)': nutrientes['THIA']?['quantity'] ?? 0.0,
      'Riboflavin (B2)': nutrientes['RIBF']?['quantity'] ?? 0.0,
      'Niacin (B3)': nutrientes['NIA']?['quantity'] ?? 0.0,
      'Vitamin B6': nutrientes['VITB6A']?['quantity'] ?? 0.0,
      'Folate equivalent (total)': nutrientes['FOLDFE']?['quantity'] ?? 0.0,
      'Folate (food)': nutrientes['FOLFD']?['quantity'] ?? 0.0,
      'Folic acid': nutrientes['FOLAC']?['quantity'] ?? 0.0,
      'Vitamin B12': nutrientes['VITB12']?['quantity'] ?? 0.0,
      'Vitamin D': nutrientes['VITD']?['quantity'] ?? 0.0,
      'Vitamin E': nutrientes['TOCPHA']?['quantity'] ?? 0.0,
      'Vitamin K': nutrientes['VITK1']?['quantity'] ?? 0.0,
    },
    'Otros': {
      'Water': nutrientes['WATER']?['quantity'] ?? 0.0,
    },
  };

  // Colores para cada categoría
  Map<String, Color> categoriaColores = {
    'Grasas': Color(0xFFA64D7C),
    'Carbohidratos y Azúcares': Color(0xFF4D7EA6),
    'Minerales': Color(0xFF8AA64D),
    'Vitaminas': Color(0xFF4DA674),
    'Otros': Color(0xFF6B6B6B),
  };

  return Container(
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: const Color(0xFFEAF8E7),
      borderRadius: BorderRadius.circular(20.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 6.0,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Información Nutricional",
          style: TextStyle(
            fontFamily: 'Comfortaa',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF023336),
          ),
        ),
        const SizedBox(height: 10),
        ...categorias.entries.map((categoriaEntry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                categoriaEntry.key,
                style: TextStyle(
                  fontFamily: 'Comfortaa',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: categoriaColores[categoriaEntry.key],
                ),
              ),
              const SizedBox(height: 5),
              ...categoriaEntry.value.entries.map((subCategoriaEntry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        subCategoriaEntry.key,
                        style: const TextStyle(
                          fontFamily: 'Comfortaa',
                          fontSize: 12,
                          color: Color(0xFF023336),
                        ),
                      ),
                      Text(
                        '${subCategoriaEntry.value.toStringAsFixed(1)} g',
                        style: const TextStyle(
                          fontFamily: 'Comfortaa',
                          fontSize: 12,
                          color: Color(0xFF6B6B6B),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              const SizedBox(height: 10),
            ],
          );
        }).toList(),
      ],
    ),
  );
}
