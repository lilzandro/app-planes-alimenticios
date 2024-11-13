import 'package:app_planes/utils/dimensiones_pantalla.dart';
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
        backgroundColor: const Color.fromARGB(255, 63, 243, 180));
  }

  List<Widget> _buildBlocks(BuildContext context) {
    return [
      Container(
        color: const Color.fromARGB(255, 63, 243, 180),
        height: DimensionesDePantalla.pantallaSize * 0.25,
      ),
      Container(
        height: DimensionesDePantalla.pantallaSize * 0.7,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
          color: Color.fromARGB(255, 255, 255, 255),
        ),
      )
    ];
  }
  // Ejemplo de datos del usuario (esto puede venir de una base de datos)
}
