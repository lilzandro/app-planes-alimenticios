import 'package:flutter/material.dart';
import 'package:app_planes/widgets/orientacion_responsive.dart';

class VentanaPerfil extends StatefulWidget {
  const VentanaPerfil({super.key});

  @override
  _VentanaPerfilState createState() => _VentanaPerfilState();
}

class _VentanaPerfilState extends State<VentanaPerfil> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
        buildBlocks: (context) => _buildBlocks(context),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255));
  }

  List<Widget> _buildBlocks(BuildContext context) {
    return [];
  }
  // Ejemplo de datos del usuario (esto puede venir de una base de datos)
}
