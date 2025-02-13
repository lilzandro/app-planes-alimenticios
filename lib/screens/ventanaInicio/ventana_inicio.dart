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
  double _totalCalorias = 0.0;
  double _totalCarbohidratos = 0.0;
  double _totalProteinas = 0.0;
  double _totalGrasas =
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
    TotalesNutrientes totales =
        PlanAlimenticioService.calcularTotalesNutrientes(_planAlimenticio);
    _totalCalorias = totales.calorias;
    _totalCarbohidratos = totales.carbohidratos;
    _totalProteinas = totales.proteinas;
    _totalGrasas = totales.grasas;
    setState(() {});
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
      buildProgressContainer(
          _totalCalorias, _totalCarbohidratos, _totalProteinas, _totalGrasas),
      // CONTENEDOR DEL PLAN ALIMENTICIO
      buildPlanAlimenticio(context, selectedMeal, setState, _planAlimenticio,
          userId, DateTime.now()),
    ];
  }
}
