import 'package:app_planes/utils/dimensiones_pantalla.dart';
import 'package:flutter/material.dart';
import 'package:app_planes/widgets/orientacion_responsive.dart';
import 'package:app_planes/widgets/perfil/editar_informacion_usuario.dart';
import 'package:app_planes/screens/Login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      backgroundColor: const Color(0xFF4DA674),
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
      color: Color(0xFF4DA674),
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
      margin: EdgeInsets.only(right: DimensionesDePantalla.pantallaSize * 0),
      padding: EdgeInsets.all(DimensionesDePantalla.pantallaSize * 0.01),
      height: DimensionesDePantalla.pantallaSize * 0.25,
      width: DimensionesDePantalla.pantallaSize * 0.18,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30.0),
          bottomLeft: Radius.circular(30.0),
        ),
        color: Color(0xFF5AC488),
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
      width: DimensionesDePantalla.pantallaSize * 0.24,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
        ),
        color: Color(0xFF5AC488),
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
      style: TextStyle(
          fontFamily: 'Comfortaa',
          fontSize: fontSize,
          color: Color(0xFF023336)),
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
        color: Color(0xFFEAF8E7),
      ),
      child: Column(
        children: [
          SizedBox(height: DimensionesDePantalla.pantallaSize * 0.05),
          _progreso(),
          SizedBox(height: DimensionesDePantalla.pantallaSize * 0.08),
          _buildActionButton("Editar Perfil", () {
            EditarInformacionUsuario.mostrar(context);
          }),
          SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
          _buildActionButton("Cerrar Sesión", () {
            _showSignOutConfirmationDialog(context);
          }),
        ],
      ),
    );
  }

  Widget _progreso() {
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
        color: Color(0xFFEAF8E7),
      ),
    );
  }

  Widget _buildActionButton(String label, VoidCallback? onPressed) {
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
          foregroundColor: label == "Cerrar Sesión"
              ? Color.fromARGB(255, 202, 67, 67)
              : Color(0xFFEAF8E7),
          backgroundColor: Color(0xFF023336), // Color del fondo
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(15.0)), // Esquinas redondeadas
        ),
        child: Text(
          label,
          style: TextStyle(fontFamily: 'Comfortaa'),
        ), // Texto del botón
      ),
    );
  }

  void _showSignOutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar cierre de sesión'),
          content: Text('¿Estás seguro de que deseas cerrar sesión?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cerrar sesión'),
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VentanaInicioSeccion()),
                    (Route<dynamic> route) => false,
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error al cerrar sesión: $e")),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
