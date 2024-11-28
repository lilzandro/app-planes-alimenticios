import 'package:app_planes/utils/dimensiones_pantalla.dart';
import 'package:app_planes/widgets/orientacion_responsive.dart';
import 'package:flutter/material.dart';

class RegistroUsuario extends StatefulWidget {
  const RegistroUsuario({super.key});

  @override
  _RegistroUsuarioState createState() => _RegistroUsuarioState();
}

class _RegistroUsuarioState extends State<RegistroUsuario> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String correo = '';
  String contrasena = '';
  String repetirContrasena = '';
  bool mostrarContrasena = false;
  bool mostrarRepetirContrasena = false;

  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
      buildBlocks: (context) => _construirBloques(context),
      backgroundColor: const Color(0xFFEAF8E7),
    );
  }

  List<Widget> _construirBloques(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return [
      SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
      AppBar(
          backgroundColor: const Color(0xFFEAF8E7),
          surfaceTintColor: Color(0xFFEAF8E7),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Color(0xFF023336),
            onPressed: () {
              Navigator.pushReplacementNamed(
                  context, '/register-2'); // Volver a datos médicos
            },
          )),
      Center(
        child: Container(
          width: screenSize.width * 0.9,
          padding: EdgeInsets.symmetric(
              horizontal: DimensionesDePantalla.pantallaSize * 0.02),
          child: _construirFormularioUsuario(),
        ),
      ),
    ];
  }

  Widget _construirFormularioUsuario() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
            Text(
              "Crear Usuario",
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.06,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: DimensionesDePantalla.pantallaSize * 0.04),
            _construirCampoTexto(
              labelText: "Correo Electrónico",
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) => setState(() => correo = value),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Ingresa tu correo";
                }
                final emailRegex = RegExp(
                    r'^[^@\s]+@[^@\s]+\.[^@\s]+$'); // Validación básica de email
                if (!emailRegex.hasMatch(value)) {
                  return "Ingresa un correo válido";
                }
                return null;
              },
            ),
            SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
            _construirCampoTexto(
              labelText: "Contraseña",
              isPassword: true,
              onChanged: (value) => setState(() => contrasena = value),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Ingresa tu contraseña";
                }
                if (value.length < 6) {
                  return "Debe tener al menos 6 caracteres";
                }
                if (!RegExp(r'[A-Z]').hasMatch(value)) {
                  return "Debe incluir al menos una letra mayúscula";
                }
                if (!RegExp(r'[0-9]').hasMatch(value)) {
                  return "Debe incluir al menos un número";
                }
                if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                  return "Debe incluir al menos un carácter especial";
                }
                return null;
              },
            ),
            SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
            _construirCampoTexto(
              labelText: "Repetir Contraseña",
              isPassword: true,
              onChanged: (value) => setState(() => repetirContrasena = value),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Repite la contraseña";
                }
                if (value != contrasena) {
                  return "Las contraseñas no coinciden";
                }
                return null;
              },
            ),
            SizedBox(height: DimensionesDePantalla.pantallaSize * 0.04),
            _construirBotonRegistrar(),
          ],
        ),
      ),
    );
  }

  Widget _construirCampoTexto({
    required String labelText,
    required ValueChanged<String> onChanged,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFC1E6BA).withOpacity(0.35),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: const Color(0xFFC1E6BA).withOpacity(0.4)),
      ),
      child: TextFormField(
        keyboardType: keyboardType,
        cursorColor: Color(0xFF023336),
        style: TextStyle(color: const Color(0xFF123456)),
        obscureText: isPassword && !(isPassword && mostrarContrasena),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle:
              TextStyle(color: const Color(0xFF023336).withOpacity(0.6)),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    mostrarContrasena ? Icons.visibility : Icons.visibility_off,
                    color: Color(0xFF023336),
                  ),
                  onPressed: () {
                    setState(() {
                      mostrarContrasena = !mostrarContrasena;
                    });
                  },
                )
              : null,
        ),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }

  Widget _construirBotonRegistrar() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF023336),
        foregroundColor: Color(0xFFEAF8E7),
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        textStyle: const TextStyle(fontSize: 18.0),
      ),
      onPressed: correo.isNotEmpty &&
              contrasena.isNotEmpty &&
              repetirContrasena.isNotEmpty &&
              _formKey.currentState!.validate()
          ? () {
              Navigator.pushReplacementNamed(context, '/home');
            }
          : null,
      child: const Text('Registrar'),
    );
  }
}
