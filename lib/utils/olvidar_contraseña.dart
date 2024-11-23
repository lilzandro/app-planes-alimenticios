import 'package:app_planes/utils/dimensiones_pantalla.dart';
import 'package:app_planes/widgets/orientacion_responsive.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecuperarContrasena extends StatefulWidget {
  const RecuperarContrasena({super.key});

  @override
  _RecuperarContrasenaState createState() => _RecuperarContrasenaState();
}

class _RecuperarContrasenaState extends State<RecuperarContrasena> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String email = '';
  String feedbackMessage = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
      buildBlocks: (context) => _construirBloques(context),
      backgroundColor: const Color.fromARGB(255, 63, 243, 180),
    );
  }

  List<Widget> _construirBloques(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return [
      SizedBox(height: DimensionesDePantalla.pantallaSize * 0.1),
      Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(45, 0, 0, 0),
                blurRadius: 4.0,
                offset: Offset(0, 0),
              ),
            ],
            borderRadius: const BorderRadius.all(Radius.circular(30.0)),
          ),
          height: screenSize.height * 0.5,
          width: screenSize.width * 0.9,
          padding: EdgeInsets.symmetric(
              horizontal: DimensionesDePantalla.pantallaSize * 0.02),
          child: _construirFormularioRecuperarContrasena(),
        ),
      ),
      SizedBox(height: DimensionesDePantalla.pantallaSize * 0.03),
    ];
  }

  Widget _construirFormularioRecuperarContrasena() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: DimensionesDePantalla.pantallaSize * 0.01),
        AppBar(
            backgroundColor: const Color.fromARGB(0, 255, 255, 255),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login'); // Volver
              },
            )),
        SizedBox(height: DimensionesDePantalla.pantallaSize * 0.04),
        Text(
          "Recuperar Contraseña",
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.06,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: DimensionesDePantalla.pantallaSize * 0.04),
        Form(
          key: _formKey,
          child: Column(
            children: [
              _construirCampoEmail(),
              SizedBox(height: DimensionesDePantalla.pantallaSize * 0.03),
              if (feedbackMessage.isNotEmpty) _construirMensajeFeedback(),
              _construirBotonEnviar(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _construirCampoEmail() {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(134, 238, 238, 238),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: const Color.fromARGB(255, 228, 228, 228)),
      ),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        cursorColor: const Color.fromARGB(255, 33, 31, 59),
        decoration: InputDecoration(
          labelText: 'Correo Electrónico',
          labelStyle: TextStyle(
              color: const Color.fromARGB(255, 33, 31, 59).withOpacity(0.6)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
              vertical: 10.0, horizontal: 10.0), // Espaciado interno
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor ingresa tu correo electrónico';
          }
          final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
          if (!emailRegex.hasMatch(value)) {
            return 'Por favor ingresa un correo electrónico válido';
          }
          return null;
        },
        onChanged: (value) => email = value,
      ),
    );
  }

  Widget _construirBotonEnviar() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 26, 33, 63),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        textStyle: const TextStyle(fontSize: 18.0),
      ),
      onPressed: isLoading
          ? null
          : () async {
              if (_formKey.currentState!.validate()) {
                await _enviarCorreoRecuperacion();
              }
            },
      child: isLoading
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : const Text('Enviar Correo'),
    );
  }

  Future<void> _enviarCorreoRecuperacion() async {
    setState(() {
      isLoading = true;
      feedbackMessage = '';
    });

    try {
      await _auth.sendPasswordResetEmail(email: email);
      setState(() {
        feedbackMessage =
            'Correo de recuperación enviado. Revisa tu bandeja de entrada.';
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        feedbackMessage =
            'Error al enviar el correo. ${e.message ?? "Inténtalo de nuevo"}';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _construirMensajeFeedback() {
    return Text(
      feedbackMessage,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: feedbackMessage.contains('Error') ? Colors.red : Colors.green,
      ),
    );
  }
}
