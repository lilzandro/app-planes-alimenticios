import 'package:app_planes/models/planAlimenticioModel.dart';
import 'package:flutter/material.dart';
import 'package:app_planes/screens/VentanaPlanAlimentacion/ventana_plan_alimentacion.dart';
import 'package:app_planes/screens/VentanaPerfil/ventana_perfil.dart';
import 'package:app_planes/screens/ventanaInicio/ventana_inicio.dart';
import 'package:app_planes/utils/dimensiones_pantalla.dart';

class Inicio extends StatefulWidget {
  final PlanAlimenticioModel? planAlimenticio;

  const Inicio({super.key, this.planAlimenticio});

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  int _selectedIndex = 0;

  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _loadPlanAlimenticio();
    _widgetOptions = <Widget>[
      const VentanaInicio(),
      VentanaPlanAlimentacion(
        planAlimenticio: widget.planAlimenticio,
      ),
      const VentanaPerfil(),
    ];

    print('UID: ${widget.planAlimenticio}');
  }

  Future<void> _loadPlanAlimenticio() async {
    // Aquí puedes cargar el plan alimenticio si es necesario
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4DA674),
      body: SafeArea(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomAppBar(
        height: DimensionesDePantalla.pantallaSize * 0.08,
        padding: const EdgeInsets.all(0),
        color: const Color(0xFFEAF8E7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, 'Inicio', 0),
            _buildNavItem(Icons.settings, 'Plan de alimentación', 1),
            _buildNavItem(Icons.person, 'Perfil', 2),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;

    return TextButton(
      onPressed: () => _onItemTapped(index),
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero, // Elimina el padding predeterminado
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Ajusta el tamaño del Column
        children: [
          Icon(icon,
              color: isSelected ? Color(0xFF023336) : Colors.black,
              size: 24), // Ajusta el tamaño del ícono
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Comfortaa', // Cambia a tu fuente Comfortaa
              color: isSelected ? Color(0xFF023336) : Colors.black,
              fontSize: 12, // Ajusta el tamaño del texto según sea necesario
            ),
          ),
        ],
      ),
    );
  }
}
