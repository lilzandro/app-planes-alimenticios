import 'package:app_planes/models/planAlimenticioModel.dart';
import 'package:app_planes/services/database_service.dart';
import 'package:app_planes/widgets/orientacion_responsive.dart';
import 'package:app_planes/widgets/inicio/Ventanainicio/indicadores.dart';
import 'package:app_planes/widgets/inicio/Ventanainicio/planAlimenticio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_planes/services/cache_service.dart';
import 'package:app_planes/utils/calculos.dart';

class VentanaInicio extends StatefulWidget {
  const VentanaInicio({super.key});

  @override
  _VentanaInicioState createState() => _VentanaInicioState();
}

class _VentanaInicioState extends State<VentanaInicio> {
  String selectedMeal = '';
  PlanAlimenticioModel? _planAlimenticio;

  /// Totales del plan
  double _totalCalorias = 0.0;
  double _totalCarbohidratos = 0.0;
  double _totalProteinas = 0.0;
  double _totalGrasas = 0.0;

  /// Progreso acumulado (según check) – se actualizarán en toggleMeal y loadMealCompletion
  double _caloriasProgreso = 0.0;
  double _carbohidratosProgreso = 0.0;
  double _proteinasProgreso = 0.0;
  double _grasasProgreso = 0.0;

  // Estados para cada comida
  Map<String, bool> mealCompletion = {
    "Desayuno": false,
    "Almuerzo": false,
    "Cena": false,
    "Merienda": false,
  };
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
    _carbohidratosProgreso = 0;
    _proteinasProgreso = 0;
    _grasasProgreso = 0;
    setState(() {});
  }

  Future<void> saveMealCompletion() async {
    final prefs = await SharedPreferences.getInstance();
    mealCompletion.forEach((meal, completed) {
      prefs.setBool(meal, completed);
    });
    String todayStr = DateTime.now().toIso8601String().split("T")[0];
    prefs.setString("mealCompletionDate", todayStr);
  }

  Future<void> loadMealCompletion() async {
    Map<String, bool> loadedMealCompletion =
        await CacheService().loadMealCompletion();
    setState(() {
      mealCompletion = loadedMealCompletion;
      _recalcularProgreso();
    });
  }

  Future<void> _saveMealCompletion() async {
    await CacheService().saveMealCompletion(mealCompletion);
  }

  void _recalcularProgreso() {
    Map<String, double> progreso =
        recalcularProgreso(mealCompletion, _planAlimenticio);
    setState(() {
      _caloriasProgreso = progreso['calorias'] ?? 0;
      _carbohidratosProgreso = progreso['carbohidratos'] ?? 0;
      _proteinasProgreso = progreso['proteinas'] ?? 0;
      _grasasProgreso = progreso['grasas'] ?? 0;
    });
  }

  // Actualización al marcar/desmarcar una comida
  void toggleMeal(String mealName, bool? value) {
    setState(() {
      mealCompletion[mealName] = value ?? false;
      _recalcularProgreso();
    });
    _saveMealCompletion();
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
      buildProgressContainer(
        _caloriasProgreso,
        _totalCalorias,
        _carbohidratosProgreso,
        _totalCarbohidratos,
        _proteinasProgreso,
        _totalProteinas,
        _totalGrasas,
        _grasasProgreso,
      ),
      buildPlanAlimenticio(
        context,
        mealCompletion,
        setState,
        _planAlimenticio,
        userId,
        DateTime.now(),
        toggleMeal,
      ),
    ];
  }
}
