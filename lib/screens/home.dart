import 'package:flutter/material.dart';
import 'package:app_planes/screens/VentanaPlanAlimentacion/ventana_plan_alimentacion.dart';
import 'package:app_planes/screens/profile_screen.dart';
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
      body: SafeArea(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      backgroundColor: const Color.fromARGB(255, 63, 243, 180),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
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
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
