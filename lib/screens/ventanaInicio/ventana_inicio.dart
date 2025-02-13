import 'package:app_planes/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:app_planes/widgets/orientacion_responsive.dart';
import 'package:app_planes/widgets/inicio/Ventanainicio/indicadores.dart';
import 'package:app_planes/widgets/inicio/Ventanainicio/planAlimenticio.dart';
import 'package:app_planes/models/planAlimenticioModel.dart';

class VentanaInicio extends StatefulWidget {
  const VentanaInicio({super.key});

  @override
  _VentanaInicioState createState() => _VentanaInicioState();
}

class _VentanaInicioState extends State<VentanaInicio> {
  String selectedMeal = ''; // Variable para almacenar la comida seleccionada
  PlanAlimenticioModel? _planAlimenticio;
  double _totalCalorias =
      0.0; // Nueva variable para almacenar el total de calorías

  @override
  void initState() {
    super.initState();
    _loadPlanAlimenticio();
  }

  String? userId;

  Future<void> _loadPlanAlimenticio() async {
    _planAlimenticio = await PlanAlimenticioService.loadPlanAlimenticio();
    // Se utiliza el método del servicio para imprimir las calorías de cada comida
    PlanAlimenticioService.printCaloriasDeCadaComida(_planAlimenticio);
    _totalCalorias = _calcularTotalCalorias();
    setState(() {});
  }

  double _calcularTotalCalorias() {
    double total = 0.0;
    DateTime today = DateTime.now();

    if (_planAlimenticio != null) {
      // Desayuno
      var desayunoDelDia = _planAlimenticio!.desayuno.where((meal) =>
          meal.fecha.day == today.day &&
          meal.fecha.month == today.month &&
          meal.fecha.year == today.year);
      if (desayunoDelDia.isNotEmpty) {
        var desayuno = desayunoDelDia.first;
        total +=
            (desayuno.nutrientes['ENERC_KCAL']['quantity'] as num).toDouble();
      }

      // Almuerzo
      var almuerzoDelDia = _planAlimenticio!.almuerzo.where((meal) =>
          meal.fecha.day == today.day &&
          meal.fecha.month == today.month &&
          meal.fecha.year == today.year);
      if (almuerzoDelDia.isNotEmpty) {
        var almuerzo = almuerzoDelDia.first;
        total +=
            (almuerzo.nutrientes['ENERC_KCAL']['quantity'] as num).toDouble();
      }

      // Merienda
      var meriendaDelDia = _planAlimenticio!.merienda1.where((meal) =>
          meal.fecha.day == today.day &&
          meal.fecha.month == today.month &&
          meal.fecha.year == today.year);
      if (meriendaDelDia.isNotEmpty) {
        var merienda = meriendaDelDia.first;
        total +=
            (merienda.nutrientes['ENERC_KCAL']['quantity'] as num).toDouble();
      }

      // Cena
      var cenaDelDia = _planAlimenticio!.cena.where((meal) =>
          meal.fecha.day == today.day &&
          meal.fecha.month == today.month &&
          meal.fecha.year == today.year);
      if (cenaDelDia.isNotEmpty) {
        var cena = cenaDelDia.first;
        total += (cena.nutrientes['ENERC_KCAL']['quantity'] as num).toDouble();
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
      buildBlocks: (context) => _buildBlocks(context),
      backgroundColor: const Color(0xFF4DA674),
    );
  }

  // Función que construye los bloques
  List<Widget> _buildBlocks(BuildContext context) {
    return [
      // CONTENEDOR DE PROGRESO (se le pasa el total de calorías)
      buildProgressContainer(_totalCalorias),
      // CONTENEDOR DEL PLAN ALIMENTICIO
      buildPlanAlimenticio(context, selectedMeal, setState, _planAlimenticio,
          userId, DateTime.now()),
    ];
  }
}
