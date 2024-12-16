import 'package:app_planes/widgets/inicio/Ventanainicio/vetanaInferior.dart';
import 'package:flutter/material.dart';
import 'package:app_planes/utils/dimensiones_pantalla.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

String? selectedMeal; // Variable para almacenar la comida seleccionada

// Contenedor con botones y plan alimenticio
Widget buildPlanAlimenticio(
    BuildContext context, String selectedMeal, Function setState) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
      color: Color(0xFFEAF8E7),
    ),
    child: Column(
      children: [
        // BOTONES
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildButton(icon: Icons.arrow_back, '', () {
              // Acción del botón izquierdo
            }),
            _buildButton('Hoy', () {
              // Acción del botón del medio
            }, isMiddleButton: true, icon: Icons.calendar_today, iconSize: 22),
            _buildButton(icon: Icons.arrow_forward, '', () {
              // Acción del botón derecho
            }),
          ],
        ),
        const SizedBox(height: 20), // Espacio entre los botones y el contenedor

        // CONTENEDOR DEL PLAN ALIMENTICIO
        SizedBox(
          height: DimensionesDePantalla.pantallaSize * 0.33,
          child: Column(
            children: [
              // DESAYUNO
              Padding(
                padding: const EdgeInsets.all(1.5),
              ),
              _buildExpandableOption('Desayuno', Colors.transparent,
                  'assets/desayuno.png', selectedMeal, setState, context),

              _buildSeparator(DimensionesDePantalla.anchoPantalla),

              // Almuerzo
              _buildExpandableOption('Almuerzo', Colors.transparent,
                  'assets/almuerzo.png', selectedMeal, setState, context),
              _buildSeparator(DimensionesDePantalla.anchoPantalla),

              // Cena
              _buildExpandableOption('Cena', Colors.transparent,
                  'assets/cena.png', selectedMeal, setState, context),
              _buildSeparator(DimensionesDePantalla.anchoPantalla),

              // Merienda
              _buildExpandableOption('Merienda', Colors.transparent,
                  'assets/merienda.png', selectedMeal, setState, context),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // CONTENEDOR DE INFORMACION DE ALIMENTOS
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
          ),
          height: DimensionesDePantalla.pantallaSize * 0.2,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30.0),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/verduras.jpg', // Ruta de tu imagen
                  fit: BoxFit.cover,
                ),
                const Center(
                  child: Text(
                    'Bloque 2',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // CONTENEDOR EXTRA
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: const Color(0xFFEAF8E7),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(45, 0, 0, 0),
                blurRadius: 4.0,
                offset: Offset(0, 0),
              ),
            ],
          ),
          height: DimensionesDePantalla.pantallaSize * 0.2,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              Flexible(
                flex: 2,
                fit: FlexFit.loose,
                child: Container(
                  decoration: const BoxDecoration(),
                  height: DimensionesDePantalla.pantallaSize * .2,
                  child: const Center(child: Text('Bloque Extra')),
                ),
              ),
            ]),
          ),
        ),
      ],
    ),
  );
}

// Función para crear las opciones expandidas
Widget _buildExpandableOption(
  String mealName,
  Color color,
  String imagePath,
  String selectedMeal,
  Function setState,
  BuildContext context,
) {
  return GestureDetector(
    onTap: () {
      // Abrir el BottomSheet al hacer clic
      showMealBottomSheet(
        context: context,
        mealName: mealName,
        imagePath: imagePath,
        selectedMeal: selectedMeal,
        color: color,
      );
    },
    child: Container(
      height: DimensionesDePantalla.pantallaSize * .08, // Tamaño fijo
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
  );
}

Widget buildCircularPercentIndicator(
    double nivelDeProgreso, double metaProgreso, String atributo) {
  const Color progressColor = Color.fromARGB(255, 185, 81, 7);
  const TextStyle textStyleBase = TextStyle(
    fontFamily: 'Comfortaa',
    color: progressColor,
  );

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CircularPercentIndicator(
        radius: 30,
        lineWidth: 5,
        percent: nivelDeProgreso / 1000,
        progressColor: progressColor,
        backgroundColor: progressColor.withOpacity(0.5),
        circularStrokeCap: CircularStrokeCap.round,
        center: Text(
          "  $nivelDeProgreso \n/$metaProgreso",
          style: textStyleBase.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        ),
      ),
      SizedBox(height: 5), // Espacio entre el círculo y el texto
      Text(
        atributo,
        style: textStyleBase.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    ],
  );
}

// Función para crear el separador
Widget _buildSeparator(double anchoPantalla) {
  return Container(
    width: DimensionesDePantalla.anchoPantalla * .9,
    height: .8,
    color: const Color(0xFF4DA674).withOpacity(0.5),
  );
}

Widget _buildButton(String? label, VoidCallback onPressed,
    {bool isMiddleButton = false, IconData? icon, double? iconSize}) {
  return Container(
    height: isMiddleButton
        ? DimensionesDePantalla.anchoPantalla * .1
        : DimensionesDePantalla.anchoPantalla * .1,
    width: isMiddleButton
        ? DimensionesDePantalla.anchoPantalla * .5
        : DimensionesDePantalla.anchoPantalla * .12,
    decoration: BoxDecoration(
      color: const Color(0xFF023336),
      borderRadius: BorderRadius.circular(30.0),
      // Esquinas redondeadas
    ),
    child: TextButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Icon(icon, size: iconSize ?? 19, color: Color(0xFFEAF8E7)),
            if (label != null)
              Text(
                label,
                style: TextStyle(
                    fontFamily: 'Comfortaa',
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFEAF8E7)),
              )
          ],
        )),
  );
}

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
      Text(
        "$nivelDeProgreso / $metaProgreso Cal",
        style: TextStyle(
          fontFamily: 'Comfortaa',
          color: Color(0xFF023336),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      LinearPercentIndicator(
        width: 150,
        lineHeight: 8,
        percent: nivelDeProgreso / 100,
        barRadius: Radius.circular(20),
        progressColor: Color(0xFF4DA674),
        backgroundColor: Color.fromARGB(255, 94, 199, 138).withOpacity(0.5),
      ),
    ],
  );
}
