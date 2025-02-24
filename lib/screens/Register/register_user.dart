import 'package:app_planes/services/registro_service.dart';
import 'package:app_planes/utils/dimensiones_pantalla.dart';
import 'package:flutter/material.dart';
import 'package:app_planes/models/registro_usuario_model.dart';
import 'package:app_planes/utils/validaciones.dart'; // Importa las validaciones

class RegistroUsuario extends StatefulWidget {
  const RegistroUsuario({super.key});

  @override
  _RegistroUsuarioState createState() => _RegistroUsuarioState();
}

class _RegistroUsuarioState extends State<RegistroUsuario> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final RegistroService _registroService = RegistroService();
  bool _isPasswordHidden = true;
  bool _isRepeatPasswordHidden = true;
  late String correo;
  late String contrasena;
  late String repetirContrasena;

  @override
  void initState() {
    super.initState();
    correo = '';
    contrasena = '';
    repetirContrasena = '';
  }

  Future<void> _registrarUsuario() async {
    await _registroService.registrarUsuario(
      context,
      _formKey,
      correo,
      contrasena,
      registroUsuario,
    );
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
            Navigator.pushReplacementNamed(context, '/register-2');
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
                      fontFamily: 'Comfortaa',
                      fontSize: MediaQuery.of(context).size.width * 0.06,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF023336)),
                ),
                SizedBox(height: DimensionesDePantalla.pantallaSize * 0.04),
                _construirCampoTexto(
                  labelText: "Correo Electrónico",
                  onChanged: (value) => setState(() => correo = value),
                  validator: validarCorreo,
                ),
                SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
                _construirCampoTexto(
                  labelText: "Contraseña",
                  isPassword: true,
                  onChanged: (value) => setState(() => contrasena = value),
                  validator: validarContrasena,
                ),
                SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
                _construirCampoTexto(
                  labelText: "Repetir Contraseña",
                  isPassword: true,
                  onChanged: (value) =>
                      setState(() => repetirContrasena = value),
                  validator: (value) =>
                      validarRepetirContrasena(value, contrasena),
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
        color: const Color(0xFFC1E6BA).withOpacity(0.35),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: const Color(0xFFC1E6BA).withOpacity(0.4)),
      ),
      child: TextFormField(
        keyboardType: keyboardType,
        cursorColor: const Color(0xFF023336),
        style: const TextStyle(
            fontFamily: 'Comfortaa',
            fontWeight: FontWeight.bold,
            color: Color(0xFF123456)),
        obscureText: isPassword
            ? (labelText == "Contraseña"
                ? _isPasswordHidden
                : _isRepeatPasswordHidden)
            : false,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
              fontFamily: 'Comfortaa',
              color: const Color(0xFF023336).withOpacity(0.6)),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    labelText == "Contraseña"
                        ? (_isPasswordHidden
                            ? Icons.visibility_off
                            : Icons.visibility)
                        : (_isRepeatPasswordHidden
                            ? Icons.visibility_off
                            : Icons.visibility),
                    color: const Color(0xFF023336).withOpacity(0.6),
                  ),
                  onPressed: () {
                    setState(() {
                      if (labelText == "Contraseña") {
                        _isPasswordHidden = !_isPasswordHidden;
                      } else if (labelText == "Repetir Contraseña") {
                        _isRepeatPasswordHidden = !_isRepeatPasswordHidden;
                      }
                    });
                  },
                )
              : null,
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
          ? _registrarUsuario
          : null,
      child: const Text('Registrar',
          style: TextStyle(
              fontFamily: 'Comfortaa',
              fontWeight: FontWeight.bold,
              color: Color(0xFFEAF8E7))), //
    );
  }
}
