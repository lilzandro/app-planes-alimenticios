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
  required double calorias,
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
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                mealName,
                                style: const TextStyle(
                                  fontFamily: 'Comfortaa',
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF023336),
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                receta,
                                style: const TextStyle(
                                  fontFamily: 'Comfortaa',
                                  color: Color(0xFF023336),
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
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
  // Clasificación de nutrientes por categorías
  Map<String, double> categorias = {
    'Calorías': nutrientes['ENERC_KCAL']?['quantity'] ?? 0.0,
    'Proteínas': nutrientes['PROCNT']?['quantity'] ?? 0.0,
    'Carbohidratos': nutrientes['CHOCDF']?['quantity'] ?? 0.0,
    'Grasas': nutrientes['FAT']?['quantity'] ?? 0.0,
  };

  // Colores para cada categoría
  Map<String, Color> categoriaColores = {
    'Calorías': Color(0xFF4DA674),
    'Proteínas': Color(0xFF8AA64D),
    'Carbohidratos': Color(0xFF4D7EA6),
    'Grasas': Color(0xFFA64D7C),
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
        ...categorias.entries.map((entry) {
          return _buildCategoria(
              entry.key, categoriaColores[entry.key]!, entry.value);
        }),
      ],
    ),
  );
}

// Método auxiliar para renderizar una categoría y sus alimentos
Widget _buildCategoria(String categoria, Color color, double valor) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          categoria,
          style: const TextStyle(
            fontFamily: 'Comfortaa',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF023336),
          ),
        ),
      ),
      // Línea de separación con color según la categoría
      Container(
        width: DimensionesDePantalla.anchoPantalla *
            0.4, // Asegura que la línea ocupe todo el ancho
        height: 2,
        color: color, // Color de la línea
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              categoria,
              style: const TextStyle(
                fontFamily: 'Comfortaa',
                fontSize: 12,
                color: Color(0xFF023336),
              ),
            ),
            Text(
              '$valor g',
              style: const TextStyle(
                fontFamily: 'Comfortaa',
                fontSize: 12,
                color: Color(0xFF6B6B6B),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
