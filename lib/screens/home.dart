import 'package:flutter/material.dart';
import 'package:app_planes/screens/VentanaPlanAlimentacion/ventana_plan_alimentacion.dart';
import 'package:app_planes/screens/VentanaPerfil/ventana_perfil.dart';
import 'package:app_planes/screens/ventanaInicio/ventana_inicio.dart';

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const VentanaInicio(),
    const VentanaPlanAlimentacion(),
    const VentanaPerfil(),
  ];

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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFEAF8E7),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            backgroundColor: Color(0xFF023336),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Plan de alimentación',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF023336),
        onTap: _onItemTapped,
      ),
    );
  }
}
