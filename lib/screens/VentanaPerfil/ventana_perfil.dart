import 'package:app_planes/models/progresoModel.dart';
import 'package:app_planes/screens/Login/login_screen.dart';
import 'package:app_planes/services/progresoServices.dart';
import 'package:app_planes/utils/reporte_page.dart.dart';
import 'package:app_planes/widgets/planAlimenticio/estadisticas.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_planes/models/registro_usuario_model.dart';
import 'package:app_planes/services/user_repository.dart';
import 'package:app_planes/services/auth_service.dart';
import 'package:app_planes/services/cache_service.dart';
import 'package:app_planes/utils/dimensiones_pantalla.dart';
import 'package:flutter/material.dart';
import 'package:app_planes/widgets/orientacion_responsive.dart';
import 'package:app_planes/widgets/perfil/editar_informacion_usuario.dart';

class VentanaPerfil extends StatefulWidget {
  const VentanaPerfil({super.key});

  @override
  _VentanaPerfilState createState() => _VentanaPerfilState();
}

class _VentanaPerfilState extends State<VentanaPerfil> {
  String? userId;
  User? user;
  RegistroUsuarioModel? registroUsuario;

  final UserRepository _userRepository = UserRepository();

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    // Obtén el id actual desde FirebaseAuth
    String? firebaseUserId = FirebaseAuth.instance.currentUser?.uid;
    print('FirebaseAuth current user id: $firebaseUserId');
    // Actualiza el userId y almacénalo en SharedPreferences
    if (firebaseUserId != null) {
      setState(() {
        userId = firebaseUserId;
      });
      await prefs.setString('userId', firebaseUserId);
      _fetchUserFromFirebase(firebaseUserId);
    } else {
      // Si no hay usuario en Firebase, limpia el userId de SharedPreferences
      await prefs.remove('userId');
      setState(() {
        userId = null;
      });
    }
  }

  Future<void> _fetchUserFromFirebase(String userId) async {
    try {
      user = FirebaseAuth.instance.currentUser;
      if (user != null && user!.uid == userId) {
        RegistroUsuarioModel? fetchedUser =
            await _userRepository.fetchUser(userId);
        if (fetchedUser != null) {
          setState(() {
            registroUsuario = fetchedUser;
          });
          // Guardar la información del usuario en caché
          await CacheService().saveUserToCache(registroUsuario!);
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

  Future<void> _handleSignOut() async {
    // Realiza el cierre de sesión
    bool didSignOut = await AuthService().signOutWithConnectivityCheck();
    if (!didSignOut) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text("No hay conexión a internet. No se puede cerrar sesión."),
        ),
      );
      return;
    }
    // Limpia el userId de SharedPreferences para evitar datos antiguos
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => VentanaInicioSeccion()),
      (route) => false,
    );
  }

  void _showSignOutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text('Confirmar cierre de sesión'),
          content: Text('¿Estás seguro de que deseas cerrar sesión?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
            TextButton(
              child: Text('Cerrar sesión'),
              onPressed: () {
                Navigator.of(ctx).pop();
                _handleSignOut();
              },
            ),
          ],
        );
      },
    );
  }

  String _getPatologias() {
    if (registroUsuario == null) return 'No disponible';
    List<String> patologias = [];
    if (registroUsuario!.diabetesTipo1) patologias.add('Diabetes Tipo 1');
    if (registroUsuario!.diabetesTipo2) patologias.add('Diabetes Tipo 2');
    if (registroUsuario!.hipertension) patologias.add('Hipertensión');
    return patologias.isNotEmpty ? patologias.join(', ') : 'Ninguna';
  }

  Widget _buildProfileText(String text, double fontSize) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Comfortaa',
        fontSize: fontSize,
        color: Color(0xFF023336),
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
          _buildProfileText('Patologías: ${_getPatologias()}',
              DimensionesDePantalla.pantallaSize * 0.015),
          _buildProfileText(
              'Nivel de actividad: ${registroUsuario?.nivelActividad ?? 'No disponible'}',
              DimensionesDePantalla.pantallaSize * 0.015),
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

  Widget _progreso() {
    // Obtiene el userId actual directamente de FirebaseAuth
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    return Container(
      padding: EdgeInsets.only(
        top: DimensionesDePantalla.pantallaSize * 0.04,
        left: DimensionesDePantalla.pantallaSize * 0.02,
        right: DimensionesDePantalla.pantallaSize * 0.02,
      ),
      height: DimensionesDePantalla.pantallaSize * 0.35,
      width: DimensionesDePantalla.pantallaSize * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        boxShadow: [
          // ...boxShadow...
        ],
        color: Color(0xFFEAF8E7),
      ),
      child: currentUserId == null
          ? Center(child: Text("No hay usuario"))
          : StreamBuilder<List<ProgresoModel>>(
              stream: FirebaseService.getProgressStream(currentUserId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("Error al cargar progreso"));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                final progressList = snapshot.data ?? [];

                /* 
                  Se asume que cada ProgresoModel corresponde a un día y contiene los valores
                  booleanos si se comió Desayuno, Almuerzo, Cena y Merienda. Se calcula el total
                  de comidas consumidas para ese día y se ubica en la posición correspondiente de la semana.
                  En Dart, DateTime.weekday retorna un número de 1 (lunes) a 7 (domingo).
                */
                List<int> dailyMealsCount = List.filled(7, 0);
                for (var progreso in progressList) {
                  int dayIndex = progreso.fecha.weekday - 1;
                  int meals = (progreso.desayuno ? 1 : 0) +
                      (progreso.almuerzo ? 1 : 0) +
                      (progreso.cena ? 1 : 0) +
                      (progreso.merienda ? 1 : 0);
                  dailyMealsCount[dayIndex] = meals;
                }
                return DailyMealsWeeklyChart(
                  dailyMealsCount: dailyMealsCount,
                );
              },
            ),
    );
  }

  Widget _buildActionButton(String label, VoidCallback? onPressed) {
    return Container(
      height: DimensionesDePantalla.anchoPantalla * .12,
      width: DimensionesDePantalla.anchoPantalla * .8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(45, 0, 0, 0),
            blurRadius: 4.0,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: label == "Cerrar Sesión"
              ? Color.fromARGB(255, 202, 67, 67)
              : Color(0xFFEAF8E7),
          backgroundColor: Color(0xFF023336),
          shadowColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        ),
        child: Text(
          label,
          style: TextStyle(fontFamily: 'Comfortaa'),
        ),
      ),
    );
  }

  Widget _buildProfileDetails() {
    return Container(
      // ... código existente ...
      child: Column(
        children: [
          SizedBox(height: DimensionesDePantalla.pantallaSize * 0.05),
          _progreso(),
          SizedBox(height: DimensionesDePantalla.pantallaSize * 0.08),
          _buildActionButton("Editar Perfil", () async {
            if (registroUsuario != null) {
              await EditarInformacionUsuario.mostrar(context, registroUsuario!);
              // Luego de cerrar el modal, vuelve a buscar y actualizar el usuario.
              if (userId != null) {
                _fetchUserFromFirebase(userId!);
              }
            }
          }),
          SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
          _buildActionButton("Ver Reporte", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ReportePage()),
            );
          }),
          SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
          _buildActionButton("Cerrar Sesión", () {
            _showSignOutConfirmationDialog(context);
          }),
          SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
      buildBlocks: (context) => [_buildProfileHeader(), _buildProfileDetails()],
      backgroundColor: const Color(0xFF4DA674),
    );
  }
}
