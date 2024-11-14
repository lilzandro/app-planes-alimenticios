// dialogo_editar_perfil.dart
import 'package:flutter/material.dart';

class EditarPerfil {
  static void mostrar(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent, // Sin bordes
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8, // 80% del ancho
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10.0,
                  offset: Offset(0, 5), // Desplazamiento de la sombra
                ),
              ],
            ),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // Ajusta la altura según el contenido
              children: [
                Text("Modificar Datos del Usuario",
                    style: TextStyle(fontSize: 20)),
                SizedBox(height: 40),
                _crearCampoTexto("Nombre:"),
                SizedBox(height: 10),
                _crearCampoTexto("Edad:"),
                SizedBox(height: 20),
                _crearCampoTexto("Fecha de Nacimiento:"),
                SizedBox(height: 20),
                _crearCampoTexto("Estatura:"),
                SizedBox(height: 20),
                _crearCampoTexto("Peso:"),
                SizedBox(height: 20),
                _crearCampoTexto("Telefono:"),
                SizedBox(height: 20),
                _crearCampoTexto("Dirección:"),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceEvenly, // Espaciado entre los botones
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pop(); // Cierra el diálogo sin guardar
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors
                            .red, // Color de fondo para el botón de cancelar
                      ),
                      child: Text("Cancelar"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Lógica para guardar los cambios
                        Navigator.of(context)
                            .pop(); // Cierra el diálogo después de guardar
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      child: Text("Guardar"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _crearCampoTexto(String etiqueta) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(etiqueta, style: TextStyle(fontSize: 16)),
        SizedBox(height: 5),
        Container(
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
            decoration: InputDecoration(
              border: InputBorder.none, // Sin borde
              contentPadding: EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: 15.0), // Espaciado interno
            ),
          ),
        ),
      ],
    );
  }
}
