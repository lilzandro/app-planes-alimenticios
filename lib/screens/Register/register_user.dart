import 'package:app_planes/utils/dimensiones_pantalla.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Asegúrate de agregar esto
import 'package:app_planes/models/registro_usuario_model.dart'; // Importa tu modelo

class RegistroUsuario extends StatefulWidget {
  const RegistroUsuario({super.key});

  @override
  _RegistroUsuarioState createState() => _RegistroUsuarioState();
}

class _RegistroUsuarioState extends State<RegistroUsuario> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String correo;
  late String contrasena;
  late String repetirContrasena;

  @override
  void initState() {
    super.initState();
    // Inicializa los valores de correo y contraseña desde el objeto global
    correo = registroUsuario.nombre ??
        ''; // Puedes usar el correo si está en el modelo
    contrasena = '';
    repetirContrasena = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF8E7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEAF8E7),
        surfaceTintColor: Color(0xFFEAF8E7),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Color(0xFF023336),
          onPressed: () {
            Navigator.pushReplacementNamed(
                context, '/register-2'); // Volver a datos médicos
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: DimensionesDePantalla.pantallaSize * 0.02),
        child: Form(
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
                  initialValue: correo,
                  onChanged: (value) => setState(() => correo = value),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Ingresa tu correo";
                    }
                    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
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
                  onChanged: (value) =>
                      setState(() => repetirContrasena = value),
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
    String? initialValue,
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
        obscureText: isPassword && !(isPassword && false),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle:
              TextStyle(color: const Color(0xFF023336).withOpacity(0.6)),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        ),
        onChanged: onChanged,
        validator: validator,
        initialValue: initialValue,
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
          ? () async {
              try {
                // Crear usuario en Firebase
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: correo,
                  password: contrasena,
                );
                // Aquí puedes guardar los demás datos del usuario en la base de datos de Firebase
                // Si usas Firestore, por ejemplo:
                FirebaseFirestore.instance.collection('usuarios').add({
                  'nombre': registroUsuario.nombre,
                  'apellido': registroUsuario.apellido,
                  'telefono': registroUsuario.telefono,
                  'fechaNacimiento':
                      registroUsuario.fechaNacimiento?.toIso8601String(),
                  'estatura': registroUsuario.estatura,
                  'peso': registroUsuario.peso,
                  'diabetesTipo1': registroUsuario.diabetesTipo1,
                  'diabetesTipo2': registroUsuario.diabetesTipo2,
                  'hipertension': registroUsuario.hipertension,
                  'nivelGlucosa': registroUsuario.nivelGlucosa,
                  'presionArterial': registroUsuario.presionArterial,
                  'observaciones': registroUsuario.observaciones,
                  'sexo': registroUsuario.sexo,
                  'nivelActividad': registroUsuario.nivelActividad,
                  'alimentosNoGustan': registroUsuario.alimentosNoGustan,
                  'alergiasIntolerancias':
                      registroUsuario.alergiasIntolerancias,
                  'nivelActividadFisica': registroUsuario.nivelActividadFisica,
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Usuario registrado exitosamente")),
                );
                // Después de registrar al usuario, navegas a la pantalla de inicio
                Navigator.pushReplacementNamed(context, '/home');
              } on FirebaseAuthException catch (e) {
                // Manejo de errores de Firebase
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:
                          Text("Error al registrar usuario: ${e.message}")),
                );
              }
            }
          : null,
      child: const Text('Registrar'),
    );
  }
}
