import 'package:app_planes/utils/dimensiones_pantalla.dart';
import 'package:app_planes/widgets/orientacion_responsive.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VentanaInicioSeccion extends StatefulWidget {
  const VentanaInicioSeccion({super.key});

  @override
  _VentanaInicioSeccionState createState() => _VentanaInicioSeccionState();
}

class _VentanaInicioSeccionState extends State<VentanaInicioSeccion> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String errorMessage = '';
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
      buildBlocks: (context) => _construirBloques(context),
      backgroundColor: Colors.white,
    );
  }

  List<Widget> _construirBloques(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return [
      Center(
        child: Container(
          width: screenSize.width * 0.85,
          padding: EdgeInsets.all(screenSize.width * 0.001),
          child: _construirFormularioInicioSesion(),
        ),
      ),
    ];
  }

  Widget _construirFormularioInicioSesion() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: DimensionesDePantalla.pantallaSize * 0.15),
        Text(
          "Inicio de Sesión",
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.06,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: DimensionesDePantalla.pantallaSize * 0.15),
        Form(
          key: _formKey,
          child: Column(
            children: [
              _construirCampoEmail(),
              SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
              _construirCampoContrasena(),
              SizedBox(height: DimensionesDePantalla.pantallaSize * 0.03),
              _construirBotonIniciarSesion(),
              SizedBox(height: DimensionesDePantalla.pantallaSize * 0.01),
              if (errorMessage.isNotEmpty) _construirMensajeError(),
              SizedBox(
                  height: DimensionesDePantalla.pantallaSize *
                      0.02), // Espacio adicional
              _construirOlvidasteContrasena(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _construirCampoEmail() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      cursorColor: const Color.fromARGB(255, 33, 31, 59),
      decoration: InputDecoration(
        labelText: 'Correo Electrónico',
        labelStyle:
            TextStyle(color: Color.fromARGB(255, 33, 31, 59).withOpacity(0.6)),
        focusedBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Color.fromARGB(255, 33, 31, 59), width: 2.0),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.5),
        ),
      ),
      validator: (value) => _validarEmail(value),
      onChanged: (value) => email = value,
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
    return TextFormField(
      obscureText: _obscurePassword,
      cursorColor: const Color.fromARGB(255, 33, 31, 59),
      decoration: InputDecoration(
        labelText: 'Contraseña',
        labelStyle:
            TextStyle(color: Color.fromARGB(255, 33, 31, 59).withOpacity(0.6)),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility : Icons.visibility_off,
            color: Color.fromARGB(255, 33, 31, 59),
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Color.fromARGB(255, 33, 31, 59), width: 2.0),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.5),
        ),
      ),
      validator: (value) => _validarContrasena(value),
      onChanged: (value) => password = value,
    );
  }

  String? _validarContrasena(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu contraseña';
    }
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  Widget _construirBotonIniciarSesion() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 26, 33, 63),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        textStyle: TextStyle(fontSize: 18.0),
      ),
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          try {
            await _auth.signInWithEmailAndPassword(
                email: email, password: password);
            print("Inicio de sesión exitoso");
          } on FirebaseAuthException catch (e) {
            setState(() {
              errorMessage = e.message ?? "Error desconocido";
            });
          }
        }
      },
      child: Text('Iniciar Sesión'),
    );
  }

  Widget _construirMensajeError() {
    return Text(
      errorMessage,
      style: const TextStyle(color: Colors.red),
    );
  }

  Widget _construirOlvidasteContrasena() {
    return TextButton(
      onPressed: () {
        // Aquí puedes agregar la lógica para navegar a la pantalla de recuperación de contraseña
        print("Navegar a la pantalla de recuperación de contraseña");
        // Por ejemplo:
        // Navigator.push(context, MaterialPageRoute(builder:(context) => RecuperarContrasenaScreen()));
      },
      child: Text('¿Olvidaste tu contraseña?',
          style: TextStyle(color: Color.fromARGB(255, 26, 33, 63))),
    );
  }
}
