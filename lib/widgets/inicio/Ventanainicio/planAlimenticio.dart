import 'package:app_planes/widgets/inicio/Ventanainicio/vetanaInferior.dart';
import 'package:flutter/material.dart';
import 'package:app_planes/utils/dimensiones_pantalla.dart';
import 'package:app_planes/models/planAlimenticioModel.dart';
import 'package:cached_network_image/cached_network_image.dart';

Widget buildPlanAlimenticio(
  BuildContext context,
  Map<String, bool> mealCompletion,
  Function setState,
  PlanAlimenticioModel? planAlimenticio,
  userId,
  DateTime selectedDate,
  Function(String, bool?) onMealToggle, // callback para actualizar
) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
      color: Color(0xFFEAF8E7),
    ),
    child: Column(
      children: [
        _buildButtonRow(selectedDate),
        const SizedBox(height: 20),
        _buildMealPlanContainer(context, mealCompletion, setState,
            planAlimenticio, selectedDate, onMealToggle),
        const SizedBox(height: 20),
        _buildImageContainer('assets/verduras.jpg', 'Plan Alimenticio'),
        const SizedBox(height: 20),
        _buildExtraContainer(),
      ],
    ),
  );
}

Widget _buildButtonRow(DateTime selectedDate) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      _buildButton(icon: Icons.arrow_back, '', () {}),
      _buildButton(' Hoy ${selectedDate.day}', () {},
          isMiddleButton: true, icon: Icons.calendar_today, iconSize: 22),
      _buildButton(icon: Icons.arrow_forward, '', () {}),
    ],
  );
}

PlanDiario? _mealForDate(List<PlanDiario> mealList, DateTime selectedDate) {
  try {
    return mealList.firstWhere((meal) =>
        meal.fecha.year == selectedDate.year &&
        meal.fecha.month == selectedDate.month &&
        meal.fecha.day == selectedDate.day);
  } catch (e) {
    return null;
  }
}

Widget _buildMealPlanContainer(
  BuildContext context,
  Map<String, bool> mealCompletion,
  Function setState,
  PlanAlimenticioModel? planAlimenticio,
  DateTime selectedDate,
  Function(String, bool?) onMealToggle,
) {
  return SizedBox(
    height: DimensionesDePantalla.pantallaSize * 0.33,
    child: Column(
      children: [
        _buildExpandableOption(
          "Desayuno",
          planAlimenticio != null
              ? _mealForDate(planAlimenticio.desayuno, selectedDate)
              : null,
          mealCompletion,
          context,
          onMealToggle,
        ),
        _buildSeparator(),
        _buildExpandableOption(
          "Almuerzo",
          planAlimenticio != null
              ? _mealForDate(planAlimenticio.almuerzo, selectedDate)
              : null,
          mealCompletion,
          context,
          onMealToggle,
        ),
        _buildSeparator(),
        _buildExpandableOption(
          "Cena",
          planAlimenticio != null
              ? _mealForDate(planAlimenticio.cena, selectedDate)
              : null,
          mealCompletion,
          context,
          onMealToggle,
        ),
        _buildSeparator(),
        _buildExpandableOption(
          "Merienda",
          planAlimenticio != null
              ? _mealForDate(planAlimenticio.merienda1, selectedDate)
              : null,
          mealCompletion,
          context,
          onMealToggle,
        ),
      ],
    ),
  );
}

Widget _buildExpandableOption(
  String mealName,
  dynamic mealData,
  Map<String, bool> mealCompletion,
  BuildContext context,
  Function(String, bool?) onMealToggle,
) {
  final String imagePath = mealData?.imagenReceta ?? 'assets/$mealName.png';
  final String receta = mealData?.nombreReceta ?? 'No disponible';
  final double gramosComida = mealData?.gramosComida ?? 0;
  final Map<String, dynamic> nutrientes = mealData?.nutrientes ?? {};
  final double proporcionComida = mealData?.proporcionComida ?? 0;
  final List<Map<String, dynamic>> informacionIngredientes =
      mealData?.informacionIngredientes ?? [];
  final List<String> intrucciones = mealData?.intrucciones ?? [];

  // Se utiliza el estado del mapa mealCompletion en lugar de selectedMeal
  final bool isSelected = mealCompletion[mealName] ?? false;
  print('Plan Alimenticio - Receta para $mealName: $receta');

  return GestureDetector(
    onTap: () {
      if (mealData == null ||
          !gramosComida.isFinite ||
          !proporcionComida.isFinite) {
        return;
      }
      showMealBottomSheet(
        context: context,
        mealName: mealName,
        imagePath: imagePath,
        imageEr: 'assets/$mealName.png',
        // Se pasa el estado actual de la selección (isSelected)
        selectedMeal: isSelected ? mealName : '',
        color: Colors.transparent,
        planDiario: [],
        receta: receta,
        gramosComida: gramosComida,
        nutrientes: nutrientes,
        proporcionComida: proporcionComida,
        informacionIngredientes: informacionIngredientes,
        intrucciones: intrucciones,
      );
    },
    child: Container(
      height: DimensionesDePantalla.pantallaSize * .08,
      // Destaca el fondo según el estado de selección
      color: isSelected
          ? const Color.fromARGB(0, 198, 4, 4)
          : const Color.fromARGB(0, 188, 17, 17),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          _buildMealImage(imagePath, mealName),
          Expanded(
            child:
                _buildMealInfo(mealName, receta, isSelected, (bool? checked) {
              onMealToggle(mealName, checked);
            }),
          ),
        ],
      ),
    ),
  );
}

Widget _buildMealInfo(String mealName, String receta, bool isSelected,
    Function(bool?) onChanged) {
  final Map<String, String> mealTimes = {
    'Desayuno': '7:00 AM',
    'Almuerzo': '12:00 PM',
    'Cena': '7:00 PM',
    'Merienda': '9:00 PM',
  };
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$mealName: ${mealTimes[mealName] ?? ''}',
              style: const TextStyle(
                fontFamily: 'Comfortaa',
                fontWeight: FontWeight.bold,
                color: Color(0xFF023336),
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              receta,
              style: const TextStyle(
                fontFamily: 'Comfortaa',
                color: Color(0xFF023336),
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      Checkbox(
        activeColor: const Color(0xFF4DA674),
        checkColor: Colors.white,
        value: isSelected,
        onChanged: onChanged,
      ),
    ],
  );
}

Widget _buildSeparator() {
  return Container(
    width: DimensionesDePantalla.anchoPantalla * .9,
    height: .9,
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
            Icon(icon, size: iconSize ?? 19, color: const Color(0xFFEAF8E7)),
          if (label != null)
            Text(
              label,
              style: const TextStyle(
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
              placeholder: (context, url) => const CircularProgressIndicator(),
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
