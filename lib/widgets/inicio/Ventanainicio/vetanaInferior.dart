import 'package:app_planes/models/planAlimenticioModel.dart';
import 'package:app_planes/widgets/planAlimenticio/detalle_comida.dart';
import 'package:app_planes/widgets/planAlimenticio/percent_indicators.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:app_planes/utils/dimensiones_pantalla.dart';
import 'package:app_planes/widgets/inicio/Ventanainicio/infoNutricional.dart';

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
  required double proporcionComida,
  required List<Map<String, dynamic>> informacionIngredientes,
  required List<String> intrucciones,
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
                            const Color(0xFF6B4DA6)),
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
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetalleComida(
                                mealName: mealName,
                                receta: receta,
                                imagePath: imagePath,
                                imageEr: imageEr,
                                gramosComida: gramosComida,
                                proporcionComida: proporcionComida,
                                informacionIngredientes:
                                    informacionIngredientes, // Reemplaza con los ingredientes reales
                                intrucciones: intrucciones,
                              ),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            imagePath.startsWith('http')
                                ? Padding(
                                    padding: EdgeInsets.only(
                                        left: DimensionesDePantalla
                                                .anchoPantalla *
                                            .03,
                                        right: DimensionesDePantalla
                                                .anchoPantalla *
                                            .03),
                                    // Espacio a la derecha de la imagen
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: imagePath,
                                        height: DimensionesDePantalla
                                                .anchoPantalla *
                                            .15,
                                        width: DimensionesDePantalla
                                                .anchoPantalla *
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
                                        DimensionesDePantalla.anchoPantalla *
                                            .2,
                                    width: DimensionesDePantalla.anchoPantalla *
                                        .22,
                                    fit: BoxFit.cover,
                                  ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$receta - ${(gramosComida).toInt()} gramos',
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
                    ),
                    SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
                    _buildSeparator(DimensionesDePantalla.anchoPantalla),
                    buildInformacionNutricional(nutrientes),
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
