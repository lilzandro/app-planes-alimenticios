import 'package:app_planes/utils/dimensiones_pantalla.dart';
import 'package:app_planes/screens/Login/olvidar_contrase%C3%B1a.dart';
import 'package:app_planes/widgets/orientacion_responsive.dart';
import 'package:app_planes/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VentanaInicioSeccion extends StatefulWidget {
  const VentanaInicioSeccion({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _VentanaInicioSesionState createState() => _VentanaInicioSesionState();
}

class _VentanaInicioSesionState extends State<VentanaInicioSeccion> {
  final AuthService _authService = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String errorMessage = '';
  bool _obscurePassword = true;
  bool showVerificationButton = false;

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
          height: screenSize.height * 0.60,
          width: screenSize.width * 0.9,
          padding: EdgeInsets.only(
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
        SizedBox(height: DimensionesDePantalla.pantallaSize * 0.01),
        AppBar(
            backgroundColor: const Color(0xFFEAF8E7),
            surfaceTintColor: Color(0xFFEAF8E7),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacementNamed(
                    context, '/start'); // Navega hacia atrás
              },
            )),
        SizedBox(height: DimensionesDePantalla.pantallaSize * 0.04),
        Text(
          "Inicio de Sesión",
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.06,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: DimensionesDePantalla.pantallaSize * 0.12),
        Form(
          key: _formKey,
          child: Column(
            children: [
              _construirCampoEmail(),
              SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
              _construirCampoContrasena(),
              SizedBox(height: DimensionesDePantalla.pantallaSize * 0.03),
              if (errorMessage.isNotEmpty) _construirMensajeError(),
              SizedBox(height: DimensionesDePantalla.pantallaSize * 0.03),
              if (showVerificationButton) _construirBotonVerificarCorreo(),

              // Espacio adicional
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
        style: TextStyle(color: const Color(0xFF123456)),
        decoration: InputDecoration(
          labelText: 'Correo Electrónico',
          labelStyle:
              TextStyle(color: const Color(0xFF023336).withOpacity(0.6)),

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
        style: TextStyle(color: const Color(0xFF123456)),
        decoration: InputDecoration(
          labelText: 'Contraseña',

          labelStyle:
              TextStyle(color: const Color(0xFF023336).withOpacity(0.6)),
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
              Navigator.pushNamed(
                  context, '/home'); // Ir a la siguiente pantalla
            }
          } on FirebaseAuthException catch (e) {
            print('FirebaseAuthException code: ${e.code}'); // Depuración
            setState(() {
              if (e.code == 'wrong-password') {
                errorMessage =
                    'La contraseña es incorrecta. Por favor, intenta de nuevo.';
              } else {
                errorMessage = 'Error al iniciar sesión';
              }
            });
          } catch (e) {
            print('Error: $e'); // Depuración
            setState(() {
              errorMessage = 'Error al iniciar sesión';
            });
          }
        }
      },
      child: Text('Iniciar Sesión'),
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
          style: TextStyle(color: Color(0xFF023336))),
    );
  }
}
