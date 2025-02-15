import 'package:app_planes/models/planAlimenticioModel.dart';
import 'package:app_planes/services/database_service.dart';
import 'package:app_planes/widgets/orientacion_responsive.dart';
import 'package:app_planes/widgets/inicio/Ventanainicio/indicadores.dart';
import 'package:app_planes/widgets/inicio/Ventanainicio/planAlimenticio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VentanaInicio extends StatefulWidget {
  const VentanaInicio({super.key});

  @override
  _VentanaInicioState createState() => _VentanaInicioState();
}

class _VentanaInicioState extends State<VentanaInicio> {
  String selectedMeal = '';
  PlanAlimenticioModel? _planAlimenticio;

  /// Meta de calorías según el plan (se asigna en _loadPlanAlimenticio)
  double _totalCalorias = 0.0;

  /// Progreso de calorías acumulado con los check (se actualiza en toggleMeal)
  double _caloriasProgreso = 0.0;

  double _totalCarbohidratos = 0.0;
  double _totalProteinas = 0.0;
  double _totalGrasas = 0.0;

  // Estados para saber si cada comida fue completada
  Map<String, bool> mealCompletion = {
    "Desayuno": false,
    "Almuerzo": false,
    "Cena": false,
    "Merienda": false,
  };

  @override
  @override
  void initState() {
    super.initState();
    _loadPlanAlimenticio().then((_) {
      loadMealCompletion();
    });
  }

  String? userId;

  Future<void> _loadPlanAlimenticio() async {
    _planAlimenticio = await PlanAlimenticioService.loadPlanAlimenticio();
    PlanAlimenticioService.printCaloriasDeCadaComida(_planAlimenticio);
    TotalesNutrientes totales =
        PlanAlimenticioService.calcularTotalesNutrientes(_planAlimenticio);
    _totalCalorias = totales.calorias;
    _totalCarbohidratos = totales.carbohidratos;
    _totalProteinas = totales.proteinas;
    _totalGrasas = totales.grasas;
    // Inicialmente, el progreso es 0
    _caloriasProgreso = 0;
    setState(() {});
  }

  Future<void> saveMealCompletion() async {
    final prefs = await SharedPreferences.getInstance();
    mealCompletion.forEach((meal, completed) {
      prefs.setBool(meal, completed);
    });
  }

  Future<void> loadMealCompletion() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      mealCompletion = {
        "Desayuno": prefs.getBool("Desayuno") ?? false,
        "Almuerzo": prefs.getBool("Almuerzo") ?? false,
        "Cena": prefs.getBool("Cena") ?? false,
        "Merienda": prefs.getBool("Merienda") ?? false,
      };
      // Recalcular el progreso según el estado guardado
      _caloriasProgreso = 0;
      mealCompletion.forEach((key, completed) {
        if (completed) {
          _caloriasProgreso += getMealCalories(key);
        }
      });
    });
  }

  // Función para obtener el plan diario (PlanDiario) de la lista para la fecha actual.
  PlanDiario? getMealForDate(List<PlanDiario> mealList, DateTime date) {
    try {
      return mealList.firstWhere((meal) =>
          meal.fecha.year == date.year &&
          meal.fecha.month == date.month &&
          meal.fecha.day == date.day);
    } catch (e) {
      return null;
    }
  }

  // Retorna las calorías reales del plan para la comida especificada (según la fecha actual)
  int getMealCalories(String mealName) {
    if (_planAlimenticio == null) return 0;
    DateTime today = DateTime.now();
    PlanDiario? diario;
    switch (mealName) {
      case "Desayuno":
        diario = getMealForDate(_planAlimenticio!.desayuno, today);
        break;
      case "Almuerzo":
        diario = getMealForDate(_planAlimenticio!.almuerzo, today);
        break;
      case "Cena":
        diario = getMealForDate(_planAlimenticio!.cena, today);
        break;
      case "Merienda":
        // Se asume que el plan usa el campo "merienda1" para la merienda
        diario = getMealForDate(_planAlimenticio!.merienda1, today);
        break;
      default:
        diario = null;
    }
    return (diario?.nutrientes['ENERC_KCAL']['quantity'] ?? 0).toInt();
  }

  // Función para manejar el cambio del checkbox usando las calorías reales del plan
  void toggleMeal(String mealName, bool? value) {
    setState(() {
      mealCompletion[mealName] = value ?? false;
      _caloriasProgreso = 0;
      mealCompletion.forEach((key, completed) {
        if (completed) {
          _caloriasProgreso += getMealCalories(key);
        }
      });
    });
    saveMealCompletion();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
      buildBlocks: (context) => _buildBlocks(context),
      backgroundColor: const Color(0xFF4DA674),
    );
  }

  List<Widget> _buildBlocks(BuildContext context) {
    return [
      // Aquí se pasa el progreso real (_caloriasProgreso) y la meta (_totalCalorias)
      buildProgressContainer(_caloriasProgreso, _totalCalorias,
          _totalCarbohidratos, _totalProteinas, _totalGrasas),
      // Se pasa el callback toggleMeal a buildPlanAlimenticio
      buildPlanAlimenticio(context, selectedMeal, setState, _planAlimenticio,
          userId, DateTime.now(), toggleMeal),
    ];
  }
}
