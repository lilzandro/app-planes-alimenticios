import 'package:app_planes/database/databaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:app_planes/widgets/orientacion_responsive.dart';
import 'package:app_planes/widgets/inicio/Ventanainicio/indicadores.dart';
import 'package:app_planes/widgets/inicio/Ventanainicio/planAlimenticio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_planes/models/planAlimenticioModel.dart';

class VentanaInicio extends StatefulWidget {
  const VentanaInicio({super.key});

  @override
  _VentanaInicioState createState() => _VentanaInicioState();
}

class _VentanaInicioState extends State<VentanaInicio> {
  String selectedMeal = ''; // Variable para almacenar la comida seleccionada
  PlanAlimenticioModel? _planAlimenticio;

  @override
  void initState() {
    super.initState();
    _loadPlanAlimenticio();
  }

  String? userId;

  Future<void> _loadPlanAlimenticio() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');
    if (userId != null) {
      DatabaseHelper _databaseHelper = DatabaseHelper();
      _planAlimenticio = await _databaseHelper.getPlanAlimenticio(userId!);
      if (_planAlimenticio != null) {
        print('Recetas del desayuno:');
        _planAlimenticio!.desayuno.forEach((planDiario) {
          print(planDiario.nombreReceta);
        });
      } else {
        print('No se encontró un plan alimenticio para este usuario');
      }
    } else {
      print('No se encontró el userId en shared_preferences');
    }
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
      // CONTENEDOR DE PROGRESO
      buildProgressContainer(),
      // CONTENEDOR DEL PLAN ALIMENTICIO
      buildPlanAlimenticio(context, selectedMeal, setState, _planAlimenticio,
          userId, DateTime.now()),
    ];
  }
}
