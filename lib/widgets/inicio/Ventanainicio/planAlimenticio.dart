import 'package:app_planes/widgets/inicio/Ventanainicio/vetanaInferior.dart';
import 'package:flutter/material.dart';
import 'package:app_planes/utils/dimensiones_pantalla.dart';
import 'package:app_planes/models/planAlimenticioModel.dart';
import 'package:cached_network_image/cached_network_image.dart';

String? selectedMeal;

Widget buildPlanAlimenticio(
  BuildContext context,
  String selectedMeal,
  Function setState,
  PlanAlimenticioModel? planAlimenticio,
  userId,
) {
  print('Plan alimenticio recibido: $planAlimenticio');

  return Container(
    padding: const EdgeInsets.all(16),
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
      color: Color(0xFFEAF8E7),
    ),
    child: Column(
      children: [
        _buildButtonRow(),
        const SizedBox(height: 20),
        _buildMealPlanContainer(
            context, selectedMeal, setState, planAlimenticio),
        const SizedBox(height: 20),
        _buildImageContainer('assets/verduras.jpg', 'Bloque 2'),
        const SizedBox(height: 20),
        _buildExtraContainer(),
      ],
    ),
  );
}

Widget _buildButtonRow() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      _buildButton(icon: Icons.arrow_back, '', () {}),
      _buildButton('Hoy', () {},
          isMiddleButton: true, icon: Icons.calendar_today, iconSize: 22),
      _buildButton(icon: Icons.arrow_forward, '', () {}),
    ],
  );
}

Widget _buildMealPlanContainer(
  BuildContext context,
  String selectedMeal,
  Function setState,
  PlanAlimenticioModel? planAlimenticio,
) {
  return SizedBox(
    height: DimensionesDePantalla.pantallaSize * 0.33,
    child: Column(
      children: [
        _buildExpandableOption(
          "Desayuno",
          planAlimenticio?.desayuno.isNotEmpty == true
              ? planAlimenticio!.desayuno[0]
              : null,
          selectedMeal,
          setState,
          context,
        ),
        _buildSeparator(),
        _buildExpandableOption(
          "Almuerzo",
          planAlimenticio?.almuerzo.isNotEmpty == true
              ? planAlimenticio!.almuerzo[0]
              : null,
          selectedMeal,
          setState,
          context,
        ),
        _buildSeparator(),
        _buildExpandableOption(
          "Merienda",
          planAlimenticio?.merienda1.isNotEmpty == true
              ? planAlimenticio!.merienda1[0]
              : null,
          selectedMeal,
          setState,
          context,
        ),
        _buildSeparator(),
        _buildExpandableOption(
          "Cena",
          planAlimenticio?.cena.isNotEmpty == true
              ? planAlimenticio!.cena[0]
              : null,
          selectedMeal,
          setState,
          context,
        ),
      ],
    ),
  );
}

Widget _buildExpandableOption(
  String mealName,
  dynamic mealData,
  String selectedMeal,
  Function setState,
  BuildContext context,
) {
  final String imagePath = mealData?.imagenReceta ?? 'assets/$mealName.png';
  final String receta = mealData?.nombreReceta ?? 'No disponible';
  final double gramosComida = mealData?.gramosComida ?? 0;
  final Map<String, dynamic> nutrientes = mealData?.nutrientes ?? {};

  print('Receta para $mealName: $receta');

  return GestureDetector(
    onTap: () {
      showMealBottomSheet(
        context: context,
        mealName: mealName,
        imagePath: imagePath,
        imageEr: 'assets/$mealName.png',
        selectedMeal: selectedMeal,
        color: Colors.transparent,
        planDiario: [],
        receta: receta,
        gramosComida: gramosComida,
        nutrientes: nutrientes,
      );
    },
    child: Container(
      height: DimensionesDePantalla.pantallaSize * .08,
      color: selectedMeal == mealName
          ? Colors.transparent
          : const Color.fromARGB(0, 188, 17, 17),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          _buildMealImage(imagePath, mealName),
          _buildMealInfo(mealName, receta),
        ],
      ),
    ),
  );
}

Widget _buildMealImage(String imagePath, String mealName) {
  return Padding(
    padding: EdgeInsets.symmetric(
        horizontal: DimensionesDePantalla.anchoPantalla * .03),
    child: ClipOval(
      child: imagePath.startsWith('http')
          ? CachedNetworkImage(
              imageUrl: imagePath,
              height: DimensionesDePantalla.anchoPantalla * .15,
              width: DimensionesDePantalla.anchoPantalla * .16,
              fit: BoxFit.cover,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Image.asset(
                'assets/$mealName.png',
                height: DimensionesDePantalla.anchoPantalla * .15,
                width: DimensionesDePantalla.anchoPantalla * .16,
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
  );
}

Widget _buildMealInfo(String mealName, String receta) {
  return Column(
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
  );
}

Widget _buildSeparator() {
  return Container(
    width: DimensionesDePantalla.anchoPantalla * .9,
    height: .8,
    color: const Color(0xFF4DA674).withOpacity(0.5),
  );
}

Widget _buildImageContainer(String imagePath, String label) {
  return Container(
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
            imagePath,
            fit: BoxFit.cover,
          ),
          Center(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildExtraContainer() {
  return Container(
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
      child: Column(
        children: [
          Flexible(
            flex: 2,
            fit: FlexFit.loose,
            child: Container(
              height: DimensionesDePantalla.pantallaSize * .2,
              child: const Center(child: Text('Bloque Extra')),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildButton(String? label, VoidCallback onPressed,
    {bool isMiddleButton = false, IconData? icon, double? iconSize}) {
  return Container(
    height: DimensionesDePantalla.anchoPantalla * .1,
    width: isMiddleButton
        ? DimensionesDePantalla.anchoPantalla * .5
        : DimensionesDePantalla.anchoPantalla * .12,
    decoration: BoxDecoration(
      color: const Color(0xFF023336),
      borderRadius: BorderRadius.circular(30.0),
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
                color: Color(0xFFEAF8E7),
              ),
            ),
        ],
      ),
    ),
  );
}
