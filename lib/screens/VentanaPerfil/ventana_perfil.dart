import 'package:app_planes/utils/dimensiones_pantalla.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app_planes/widgets/orientacion_responsive.dart';
import 'package:app_planes/widgets/perfil/editar_informacion_usuario.dart';
import 'package:app_planes/screens/Login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_planes/models/registro_usuario_model.dart';

class VentanaPerfil extends StatefulWidget {
  const VentanaPerfil({super.key});

  @override
  _VentanaPerfilState createState() => _VentanaPerfilState();
}

class _VentanaPerfilState extends State<VentanaPerfil> {
  String? userId;
  User? user;
  RegistroUsuarioModel? registroUsuario;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
    });

    if (userId != null) {
      _fetchUserFromFirebase(userId!);
    }
  }

  Future<void> _fetchUserFromFirebase(String userId) async {
    try {
      user = FirebaseAuth.instance.currentUser;
      if (user != null && user!.uid == userId) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(userId)
            .get();
        if (userDoc.exists) {
          setState(() {
            registroUsuario = RegistroUsuarioModel(
              nombre: userDoc['nombre'],
              apellido: userDoc['apellido'],
              edad: userDoc['edad'],
              estatura: userDoc['estatura'],
              peso: userDoc['peso'],
              sexo: userDoc['sexo'],
              nivelActividad: userDoc['nivelActividad'],
            );
          });
          // Guardar la información del usuario en SharedPreferences
          await _saveUserToCache(registroUsuario!);
          print('Usuario encontrado: ${registroUsuario!.nombre}');
        } else {
          print('No se encontró el usuario en Firestore');
        }
      } else {
        print('No se encontró el usuario en Firebase');
      }
    } catch (e) {
      print('Error al buscar el usuario en Firebase: $e');
    }
  }

  Future<void> _saveUserToCache(RegistroUsuarioModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('nombre', user.nombre ?? '');
    await prefs.setString('apellido', user.apellido ?? '');
    await prefs.setInt('edad', user.edad ?? 0);
    await prefs.setDouble('estatura', user.estatura ?? 0.0);
    await prefs.setDouble('peso', user.peso ?? 0.0);
    await prefs.setString('sexo', user.sexo ?? '');
    await prefs.setString('nivelActividad', user.nivelActividad ?? '');
  }

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
              '${registroUsuario?.nombre ?? 'Nombre no disponible'} ${registroUsuario?.apellido ?? ''}',
              DimensionesDePantalla.pantallaSize * 0.02),
          _buildProfileText('Edad: ${registroUsuario?.edad ?? 'No disponible'}',
              DimensionesDePantalla.pantallaSize * 0.015),
          _buildProfileText(
              'Estatura: ${registroUsuario?.estatura ?? 'No disponible'} m',
              DimensionesDePantalla.pantallaSize * 0.015),
          _buildProfileText(
              'Peso: ${registroUsuario?.peso ?? 'No disponible'} kg',
              DimensionesDePantalla.pantallaSize * 0.015),
          _buildProfileText('Sexo: ${registroUsuario?.sexo ?? 'No disponible'}',
              DimensionesDePantalla.pantallaSize * 0.015),
          _buildProfileText(
              'Nivel de actividad: ${registroUsuario?.nivelActividad ?? 'No disponible'}',
              DimensionesDePantalla.pantallaSize * 0.015),
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
            if (registroUsuario != null) {
              EditarInformacionUsuario.mostrar(context, registroUsuario!);
            }
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
