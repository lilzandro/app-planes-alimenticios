import 'package:app_planes/models/planAlimenticioModel.dart';
import 'package:app_planes/screens/home.dart';
import 'package:app_planes/utils/dimensiones_pantalla.dart';
import 'package:app_planes/screens/Login/olvidar_contrase%C3%B1a.dart';
import 'package:app_planes/widgets/orientacion_responsive.dart';
import 'package:app_planes/services/auth_service.dart';
import 'package:app_planes/database/databaseHelper.dart' as db_helper2;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VentanaInicioSeccion extends StatefulWidget {
  const VentanaInicioSeccion({super.key});

  @override
  _VentanaInicioSesionState createState() => _VentanaInicioSesionState();
}

class _VentanaInicioSesionState extends State<VentanaInicioSeccion> {
  final AuthService _authService = AuthService();
  final db_helper2.DatabaseHelper _databaseHelper = db_helper2.DatabaseHelper();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String errorMessage = '';
  bool _obscurePassword = true;
  bool showVerificationButton = false;
  bool isLoading = false;
  PlanAlimenticioModel? planAlimenticio;

  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
      buildBlocks: (context) => _construirBloques(context),
      backgroundColor: Color(0xFF4DA674),
    );
  }

  List<Widget> _construirBloques(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return [
      SizedBox(height: DimensionesDePantalla.pantallaSize * 0.08),
      Center(
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFEAF8E7),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(45, 0, 0, 0),
                blurRadius: 4.0,
                offset: Offset(0, 0),
              ),
            ],
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
          ),
          width: screenSize.width * 0.9,
          padding: EdgeInsets.only(
              bottom: DimensionesDePantalla.pantallaSize * 0.02,
              left: DimensionesDePantalla.pantallaSize * 0.02,
              right: DimensionesDePantalla.pantallaSize * 0.02),
          child: _construirFormularioInicioSesion(),
        ),
      ),
      SizedBox(height: DimensionesDePantalla.pantallaSize * 0.03),
      _construirBotonIniciarSesion(),
      _construirOlvidasteContrasena(),
    ];
  }

  Widget _construirFormularioInicioSesion() {
    return Column(
      children: [
        AppBar(
          backgroundColor: const Color.fromARGB(0, 234, 248, 231),
          surfaceTintColor: Color(0xFFEAF8E7),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacementNamed(
                  context, '/start'); // Navega hacia atrás
            },
          ),
        ),
        SizedBox(height: DimensionesDePantalla.pantallaSize * 0.04),
        Text(
          "Inicio de Sesión",
          style: TextStyle(
            fontFamily: 'Comfortaa',
            fontSize: MediaQuery.of(context).size.width * 0.06,
            fontWeight: FontWeight.bold,
            color: Color(0xFF023336),
          ),
        ),
        SizedBox(
            height: DimensionesDePantalla.pantallaSize *
                0.08), // Reducir el tamaño del espacio
        Form(
          key: _formKey,
          child: Column(
            children: [
              _construirCampoEmail(),
              SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
              _construirCampoContrasena(),
              SizedBox(
                  height: DimensionesDePantalla.pantallaSize *
                      0.02), // Reducir el tamaño del espacio
              if (errorMessage.isNotEmpty) _construirMensajeError(),
              SizedBox(
                  height: DimensionesDePantalla.pantallaSize *
                      0.01), // Reducir el tamaño del espacio
              if (showVerificationButton) _construirBotonVerificarCorreo(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _construirCampoEmail() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFC1E6BA)
            .withOpacity(0.35), // Color de fondo del input
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: const Color(0xFFC1E6BA).withOpacity(0.4)),
        // Esquinas redondeadas
      ),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        cursorColor: const Color(0xFF023336),
        style: TextStyle(
            fontFamily: 'Comfortaa',
            color: const Color(0xFF123456),
            fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          labelText: 'Correo Electrónico',
          labelStyle: TextStyle(
              fontFamily: 'Comfortaa',
              color: const Color(0xFF023336).withOpacity(0.6)),

          border: InputBorder.none, // Sin borde visible
          contentPadding: EdgeInsets.symmetric(
              vertical: 10.0, horizontal: 10.0), // Espaciado interno
        ),
        validator: (value) => _validarEmail(value),
        onChanged: (value) => email = value,
      ),
    );
  }

  String? _validarEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu correo electrónico';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Por favor ingresa un correo electrónico válido';
    }
    return null;
  }

  Widget _construirCampoContrasena() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFC1E6BA)
            .withOpacity(0.35), // Color de fondo del input
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: const Color(0xFFC1E6BA).withOpacity(0.4)),
        // Esquinas redondea        border: Border.all(color: const Color(0xFFC1E6BA).withOpacity(0.4)),
      ),
      child: TextFormField(
        obscureText: _obscurePassword,
        cursorColor: const Color(0xFF023336),
        style: TextStyle(
            fontFamily: 'Comfortaa',
            color: const Color(0xFF123456),
            fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          labelText: 'Contraseña',

          labelStyle: TextStyle(
              fontFamily: 'Comfortaa',
              color: const Color(0xFF023336).withOpacity(0.6)),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility : Icons.visibility_off,
              color: Color(0xFF023336),
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
          border: InputBorder.none, // Sin borde visible
          contentPadding: EdgeInsets.symmetric(
              vertical: 10.0, horizontal: 10.0), // Espaciado interno
        ),
        validator: (value) => _validarContrasena(value),
        onChanged: (value) => password = value,
      ),
    );
  }

  String? _validarContrasena(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu contraseña';
    }
    return null;
  }

  Widget _construirBotonIniciarSesion() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF023336),
        foregroundColor: Color(0xFFEAF8E7),
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        textStyle: TextStyle(fontSize: 18.0),
      ),
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          setState(() {
            isLoading = true;
          });
          try {
            // Verificar si el correo electrónico existe
            bool usuarioExistente =
                await _authService.verificarUsuarioExistente(email);
            if (!usuarioExistente) {
              setState(() {
                errorMessage =
                    'No se encontró una cuenta con este correo electrónico.';
              });
              return;
            }

            // Intentar iniciar sesión
            UserCredential userCredential =
                await _authService.iniciarSesion(email, password);

            if (!userCredential.user!.emailVerified) {
              setState(() {
                errorMessage =
                    'Tu correo electrónico no ha sido verificado. Por favor, verifica tu correo para inciar sesión.';
                showVerificationButton = true;
              });
            } else {
              print(
                  'Usuario autenticado: ${userCredential.user!.uid}'); // Depuración

              // Guardar el userId en shared_preferences
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString('userId', userCredential.user!.uid);

              // Buscar el plan alimenticio del usuario en la base de datos local
              planAlimenticio = await _databaseHelper
                  .getPlanAlimenticio(userCredential.user!.uid);

              if (planAlimenticio != null) {
                print(
                    'Plan alimenticio encontrado localmente: ${planAlimenticio!.desayuno}');
              } else {
                print(
                    'No se encontró un plan alimenticio local para este usuario. Buscando en Firebase...');
                try {
                  // Buscar en Firestore el plan alimenticio asociado al usuario.
                  final planSnapshot = await FirebaseFirestore.instance
                      .collection('planesAlimenticios')
                      .where('usuarioId', isEqualTo: userCredential.user!.uid)
                      .get();

                  if (planSnapshot.docs.isNotEmpty) {
                    // Suponiendo que la estructura en Firestore coincide con la de PlanAlimenticioModel.fromJson.
                    final planData = planSnapshot.docs.first.data();
                    planAlimenticio = PlanAlimenticioModel.fromJson(planData);

                    // Guardar el plan alimenticio localmente.
                    await _databaseHelper.insertPlanAlimenticio(
                        userCredential.user!.uid, planAlimenticio!);

                    print(
                        'Plan alimenticio recuperado de Firebase y guardado localmente.');
                  } else {
                    print('No se encontró plan alimenticio en Firebase.');
                  }
                } catch (e) {
                  print('Error al recuperar plan alimenticio de Firebase: $e');
                }
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Inicio(planAlimenticio: planAlimenticio),
                ),
              ); // Ir a la siguiente pantalla
            }
          } on FirebaseAuthException catch (e) {
            print('FirebaseAuthException code: ${e.code}'); // Depuración
            setState(() {
              if (e.code == 'wrong-password') {
                errorMessage =
                    'La contraseña es incorrecta. Por favor, intenta de nuevo.';
              } else {
                errorMessage = 'Error al iniciar sesión, revisa tu conexión.';
              }
            });
          } catch (e) {
            print('Error: $e'); // Depuración
            setState(() {
              errorMessage = 'Error al iniciar sesión';
            });
          } finally {
            setState(() {
              isLoading = false;
            });
          }
        }
      },
      child: isLoading
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Color(0xFFEAF8E7),
              ),
            )
          : const Text('Iniciar Sesión',
              style: TextStyle(
                  fontFamily: 'Comfortaa',
                  color: Color(0xFFEAF8E7),
                  fontWeight: FontWeight.bold)),
    );
  }

  Widget _construirBotonVerificarCorreo() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF023336),
        foregroundColor: Color(0xFFEAF8E7),
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      ),
      onPressed: () async {
        try {
          await _authService.enviarCorreoVerificacionActual();
          setState(() {
            errorMessage =
                'Correo de verificación enviado. Por favor, revisa tu bandeja de entrada.';
            showVerificationButton = false;
          });
        } catch (e) {
          print('Error: $e'); // Depuración
          setState(() {
            errorMessage = 'Error al enviar el correo de verificación.';
          });
        }
      },
      child: Text('Verificar Correo'),
    );
  }

  Widget _construirMensajeError() {
    return Text(
      errorMessage,
      style: const TextStyle(color: Color(0xFFBB3026)),
    );
  }

  Widget _construirOlvidasteContrasena() {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RecuperarContrasena()),
        );
      },
      child: Text('¿Olvidaste tu contraseña?',
          style: TextStyle(
            color: Color(0xFF023336),
            fontFamily: 'Comfortaa',
            fontWeight: FontWeight.bold,
          )),
    );
  }
}
