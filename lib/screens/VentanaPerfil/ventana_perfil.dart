import 'package:app_planes/utils/dimensiones_pantalla.dart';
import 'package:flutter/material.dart';
import 'package:app_planes/widgets/orientacion_responsive.dart';
import 'package:app_planes/widgets/editar_perfil.dart';

class VentanaPerfil extends StatefulWidget {
  const VentanaPerfil({super.key});

  @override
  _VentanaPerfilState createState() => _VentanaPerfilState();
}

class _VentanaPerfilState extends State<VentanaPerfil> {
  static const Color backgroundColor = Color.fromARGB(255, 63, 243, 180);
  static const Color avatarBackgroundColor = Color.fromARGB(255, 46, 192, 140);
  static const Color buttonBackgroundColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
      buildBlocks: (context) => _buildBlocks(context),
      backgroundColor: backgroundColor,
    );
  }

  List<Widget> _buildBlocks(BuildContext context) {
    return [
      _buildProfileHeader(),
      _buildProfileDetails(),
    ];
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: EdgeInsets.all(DimensionesDePantalla.pantallaSize * 0.01),
      color: backgroundColor,
      height: DimensionesDePantalla.pantallaSize * 0.25,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildAvatar(),
          _buildProfileInfo(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      padding: EdgeInsets.all(DimensionesDePantalla.pantallaSize * 0.02),
      height: DimensionesDePantalla.pantallaSize * 0.25,
      width: DimensionesDePantalla.pantallaSize * 0.21,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30.0),
          bottomLeft: Radius.circular(30.0),
        ),
        color: avatarBackgroundColor,
      ),
      child: Image.asset(
        'assets/avatar.png',
        width: DimensionesDePantalla.pantallaSize * 0.2,
        height: DimensionesDePantalla.pantallaSize * 0.2,
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Container(
      height: DimensionesDePantalla.pantallaSize * 0.25,
      width: DimensionesDePantalla.pantallaSize * 0.21,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
        ),
        color: avatarBackgroundColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileText(
              'Lizandro Castillo', DimensionesDePantalla.pantallaSize * 0.02),
          _buildProfileText('Patología: Diabetes tipo 2',
              DimensionesDePantalla.pantallaSize * 0.015),
          _buildProfileText(
              'Edad: 22 años', DimensionesDePantalla.pantallaSize * 0.015),
          _buildProfileText(
              'Estatura: 1.68 m', DimensionesDePantalla.pantallaSize * 0.015),
          _buildProfileText(
              'Peso: 55 kg', DimensionesDePantalla.pantallaSize * 0.015),
        ],
      ),
    );
  }

  Widget _buildProfileText(String text, double fontSize) {
    return Text(
      text,
      style: TextStyle(fontSize: fontSize),
    );
  }

  Widget _buildProfileDetails() {
    return Container(
      padding: EdgeInsets.all(DimensionesDePantalla.pantallaSize * 0.02),
      height: DimensionesDePantalla.pantallaSize * 0.7,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        color: buttonBackgroundColor,
      ),
      child: Column(
        children: [
          SizedBox(height: DimensionesDePantalla.pantallaSize * 0.05),
          _buildDetailCard(),
          SizedBox(height: DimensionesDePantalla.pantallaSize * 0.08),
          _buildActionButton("Editar Perfil", () {
            EditarPerfil.mostrar(context);
          }),
          SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
          _buildActionButton("Cerrar Sección", () {}),
        ],
      ),
    );
  }

  Widget _buildDetailCard() {
    return Container(
      height: DimensionesDePantalla.pantallaSize * 0.25,
      width: DimensionesDePantalla.pantallaSize * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(45, 0, 0, 0),
            blurRadius: 4.0,
            offset: Offset(0, 0),
          ),
        ],
        color: buttonBackgroundColor,
      ),
    );
  }

  Widget _buildActionButton(String label, VoidCallback onPressed) {
    return Container(
      height: DimensionesDePantalla.anchoPantalla * .12,
      width: DimensionesDePantalla.anchoPantalla * .5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(45, 0, 0, 0),
            blurRadius: 4.0,
            offset: Offset(0, 0), // Desplazamiento de la sombra
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: label == "Cerrar Sección"
              ? Color.fromARGB(255, 187, 13, 13)
              : Color.fromARGB(255, 0, 0, 0),
          backgroundColor: buttonBackgroundColor, // Color del fondo
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(15.0)), // Esquinas redondeadas
        ),
        child: Text(label), // Texto del botón
      ),
    );
  }
}
