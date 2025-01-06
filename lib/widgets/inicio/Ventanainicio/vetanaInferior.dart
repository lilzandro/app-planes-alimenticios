import 'package:flutter/material.dart';
import 'package:app_planes/utils/dimensiones_pantalla.dart';
import 'package:percent_indicator/percent_indicator.dart'; // Si usas percent_indicator.

/// Función para mostrar el BottomSheet.
void showMealBottomSheet({
  required BuildContext context,
  required String mealName,
  required String imagePath,
  required String selectedMeal,
  required Color color,
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
                        buildLinearPercentIndicator("Calorías", 80, 500),
                      ],
                    ),
                    SizedBox(height: DimensionesDePantalla.pantallaSize * 0.04),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildCircularPercentIndicator(
                            11, 25, "Proteínas", const Color(0xFF8AA64D)),
                        buildCircularPercentIndicator(
                            11, 25, "Carbohidratos", const Color(0xFF4D7EA6)),
                        buildCircularPercentIndicator(
                            11, 25, "Grasas", const Color(0xFFA64D7C)),
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
                          Image.asset(
                            imagePath,
                            height: DimensionesDePantalla.anchoPantalla * .2,
                            width: DimensionesDePantalla.anchoPantalla * .22,
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
                              const Text(
                                'Alimentos',
                                style: TextStyle(
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
                    _buildInformacionNutricional(),
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

Widget buildLinearPercentIndicator(
    String nombre, double nivelDeProgreso, double metaProgreso) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        "${nivelDeProgreso}g / $metaProgreso Kcal",
        style: TextStyle(
          fontFamily: 'Comfortaa',
          color: Color(0xFF023336),
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
      LinearPercentIndicator(
        width: 120,
        lineHeight: 6,
        percent: nivelDeProgreso / 100,
        barRadius: Radius.circular(20),
        progressColor: Color(0xFF4DA674),
        backgroundColor: Color(0xFF4DA674).withOpacity(0.5),
      ),
    ],
  );
}

Widget buildCircularPercentIndicator(
    double nivelDeProgreso, double metaProgreso, String label, Color color) {
  Color progressColor = color;
  TextStyle textStyleBase = TextStyle(
    fontFamily: 'Comfortaa',
    color: progressColor,
  );

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CircularPercentIndicator(
        radius: 30,
        lineWidth: 5,
        percent: nivelDeProgreso / 100,
        progressColor: progressColor,
        backgroundColor: progressColor.withOpacity(0.5),
        circularStrokeCap: CircularStrokeCap.round,
        center: Text(
          "  $nivelDeProgreso\n /$metaProgreso",
          style: textStyleBase.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Color(0xFF023336)),
        ),
      ),
      const SizedBox(height: 8),
      Text(
        label,
        style: textStyleBase.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 10,
            color: Color(0xFF023336)),
      ),
    ],
  );
}

Widget _buildInformacionNutricional() {
  // Datos de ejemplo de alimentos
  List<Map<String, dynamic>> alimentos = [
    {
      'nombre': 'Pollo a la parrilla',
      'calorias': 150,
      'proteinas': 25,
      'carbohidratos': 0,
      'grasas': 5
    },
    {
      'nombre': 'Arroz integral',
      'calorias': 200,
      'proteinas': 5,
      'carbohidratos': 45,
      'grasas': 2
    },
    {
      'nombre': 'Zanahoria',
      'calorias': 35,
      'proteinas': 1,
      'carbohidratos': 8,
      'grasas': 0
    },
  ];

  // Clasificación de alimentos por categorías
  Map<String, List<Map<String, dynamic>>> categorias = {
    'Calorías': alimentos,
    'Proteínas': alimentos.where((a) => a['proteinas'] > 0).toList(),
    'Carbohidratos': alimentos.where((a) => a['carbohidratos'] > 0).toList(),
    'Grasas': alimentos.where((a) => a['grasas'] > 0).toList(),
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
Widget _buildCategoria(
    String categoria, Color color, List<Map<String, dynamic>> alimentos) {
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
      Column(
        children: alimentos
            .map((alimento) => _buildDetallePorCategoria(alimento, categoria))
            .toList(),
      ),
    ],
  );
}

// Método auxiliar para renderizar los valores específicos de cada alimento según la categoría
Widget _buildDetallePorCategoria(
    Map<String, dynamic> alimento, String categoria) {
  String valorNutricional;
  switch (categoria) {
    case 'Calorías':
      valorNutricional = '${alimento['calorias']} kcal';
      break;
    case 'Proteínas':
      valorNutricional = '${alimento['proteinas']} g';
      break;
    case 'Carbohidratos':
      valorNutricional = '${alimento['carbohidratos']} g';
      break;
    case 'Grasas':
      valorNutricional = '${alimento['grasas']} g';
      break;
    default:
      valorNutricional = 'N/A';
  }

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          alimento['nombre'] ?? 'Sin nombre',
          style: const TextStyle(
            fontFamily: 'Comfortaa',
            fontSize: 12,
            color: Color(0xFF023336),
          ),
        ),
        Text(
          valorNutricional,
          style: const TextStyle(
            fontFamily: 'Comfortaa',
            fontSize: 12,
            color: Color(0xFF6B6B6B),
          ),
        ),
      ],
    ),
  );
}
