import 'package:app_planes/utils/dimensiones_pantalla.dart';
import 'package:app_planes/widgets/orientacion_responsive.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VentanaRegistro extends StatefulWidget {
  const VentanaRegistro({super.key});

  @override
  _VentanaRegistroState createState() => _VentanaRegistroState();
}

class _VentanaRegistroState extends State<VentanaRegistro> {
  final _auth = FirebaseAuth.instance;
  String nombre = '';
  String email = '';

  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
      buildBlocks: (context) => _construirBloques(context),
      backgroundColor: Colors.white,
    );
  }

  List<Widget> _construirBloques(BuildContext context) {
    return [
      SizedBox(height: DimensionesDePantalla.pantallaSize * 0.10),
      Center(
        child: Text(
          "Datos personales",
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.06,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      SizedBox(height: DimensionesDePantalla.pantallaSize * 0.05),
      Center(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _crearCampoTexto("Nombre:", (value) {
                  setState(() {
                    nombre = value;
                  });
                }),
                SizedBox(height: 20),
                _crearCampoTexto("Correo:", (value) {
                  setState(() {
                    email = value;
                  });
                }),
                SizedBox(height: 20),
                _crearBotones(context), // Botones de registrar y cancelar
              ],
            ),
          ),
        ),
      )
    ];
  }

  Widget _crearCampoTexto(String etiqueta, Function(String) onChanged) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 10),
        Expanded(
          child: Text(etiqueta, style: TextStyle(fontSize: 16)),
        ),
        Expanded(
          flex: 3, // Ajusta el tamaño del campo de texto
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5.0,
                  offset: Offset(0, 2), // Desplazamiento de la sombra
                ),
              ],
            ),
            child: TextField(
              onChanged: onChanged, // Actualiza el valor al cambiar
              decoration: InputDecoration(
                border: InputBorder.none, // Sin borde
                contentPadding: EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 10.0), // Espaciado interno
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _crearBotones(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 26, 33, 63),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        textStyle: TextStyle(fontSize: 18.0),
      ),
      onPressed: () async {},
      child: Text('Iniciar Sesión'),
    );
  }
}
